#ifndef OPENMC_TALLY_FILTER_MESH_H
#define OPENMC_TALLY_FILTER_MESH_H

#include <cstdint>
#include <sstream>

#include "openmc/capi.h"
#include "openmc/error.h"
#include "openmc/mesh.h"
#include "openmc/tallies/tally_filter.h"


namespace openmc {

class MeshFilter : public TallyFilter
{
public:
  virtual ~MeshFilter() override = default;

  virtual void
  from_xml(pugi::xml_node node) override
  {
    auto bins_ = get_node_array<int32_t>(node, "bins");
    if (bins_.size() != 1)
      fatal_error("Only one mesh can be specified per mesh filter.");

    auto id = bins_[0];
    auto search = mesh_map.find(id);
    if (search != mesh_map.end()) {
      mesh_ = search->second;
    } else{
      std::stringstream err_msg;
      err_msg << "Could not find cell " << id << " specified on tally filter.";
      fatal_error(err_msg);
    }

    n_bins_ = 1;
    for (auto dim : meshes[mesh_]->shape_) n_bins_ *= dim;
  }

  virtual void
  get_all_bins(Particle* p, int estimator, TallyFilterMatch& match)
  const override
  {
    if (estimator != ESTIMATOR_TRACKLENGTH) {
      auto bin = meshes[mesh_]->get_bin(p->coord[0].xyz);
      if (bin >= 0) {
        match.bins.push_back(bin);
        match.weights.push_back(1.0);
      }
    } else {
      meshes[mesh_]->bins_crossed(p, match.bins, match.weights);
    }
  }

  virtual void
  to_statepoint(hid_t filter_group) const override
  {
    write_dataset(filter_group, "type", "mesh");
    write_dataset(filter_group, "n_bins", n_bins_);
    write_dataset(filter_group, "bins", meshes[mesh_]->id_);
  }

  virtual std::string
  text_label(int bin) const override
  {
    auto& mesh = *meshes[mesh_];
    int n_dim = mesh.n_dimension_;

    int ijk[n_dim];
    mesh.get_indices_from_bin(bin, ijk);

    std::stringstream out;
    out << "Mesh Index (" << ijk[0];
    if (n_dim > 1) out << ", " << ijk[1];
    if (n_dim > 2) out << ", " << ijk[2];
    out << ")";

    return out.str();
  }

  int32_t mesh_;
};

} // namespace openmc
#endif // OPENMC_TALLY_FILTER_MESH_H
