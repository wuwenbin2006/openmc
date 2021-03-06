import openmc
import openmc.capi
from openmc.stats import Box

import pytest
from tests.testing_harness import PyAPITestHarness

pytestmark = pytest.mark.skipif(
    not openmc.capi.dagmc_enabled,
    reason="DAGMC CAD geometry is not enabled.")

def test_dagmc():
    model = openmc.model.Model()

    # settings
    model.settings.batches = 5
    model.settings.inactive = 0
    model.settings.particles = 100

    source = openmc.Source(space=Box([-4, -4, -4],
                                     [ 4,  4,  4]))
    model.settings.source = source

    model.settings.dagmc = True
    
    # tally
    tally = openmc.Tally()
    tally.scores = ['total']
    tally.filters = [openmc.CellFilter(1)]
    model.tallies = [tally]

    # materials
    u235 = openmc.Material()
    u235.add_nuclide('U235', 1.0, 'ao')
    u235.set_density('g/cc', 11)
    u235.id = 40

    water = openmc.Material()
    water.add_nuclide('H1', 2.0, 'ao')
    water.add_nuclide('O16', 1.0, 'ao')
    water.add_s_alpha_beta('c_H_in_H2O')
    water.set_density('g/cc', 1.0)
    water.id = 41

    mats = openmc.Materials([u235, water])
    model.materials = mats

    harness = PyAPITestHarness('statepoint.5.h5', model=model)
    harness.main()
