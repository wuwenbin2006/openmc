module endf

  use constants
  use string, only: to_str

  implicit none

contains

!===============================================================================
! REACTION_NAME gives the name of the reaction for a given MT value
!===============================================================================

  pure function reaction_name(MT) result(string)

    integer, intent(in) :: MT
    character(MAX_WORD_LEN) :: string

    select case (MT)
    ! Special reactions for tallies
    case (SCORE_FLUX)
      string = "flux"
    case (SCORE_TOTAL)
      string = "total"
    case (SCORE_SCATTER)
      string = "scatter"
    case (SCORE_NU_SCATTER)
      string = "nu-scatter"
    case (SCORE_ABSORPTION)
      string = "absorption"
    case (SCORE_FISSION)
      string = "fission"
    case (SCORE_NU_FISSION)
      string = "nu-fission"
    case (SCORE_DECAY_RATE)
      string = "decay-rate"
    case (SCORE_DELAYED_NU_FISSION)
      string = "delayed-nu-fission"
    case (SCORE_PROMPT_NU_FISSION)
      string = "prompt-nu-fission"
    case (SCORE_KAPPA_FISSION)
      string = "kappa-fission"
    case (SCORE_CURRENT)
      string = "current"
    case (SCORE_EVENTS)
      string = "events"
    case (SCORE_INVERSE_VELOCITY)
      string = "inverse-velocity"
    case (SCORE_FISS_Q_PROMPT)
      string = "fission-q-prompt"
    case (SCORE_FISS_Q_RECOV)
      string = "fission-q-recoverable"

    ! Normal ENDF-based reactions
    case (TOTAL_XS)
      string = '(n,total)'
    case (ELASTIC)
      string = '(n,elastic)'
    case (N_LEVEL)
      string = '(n,level)'
    case (N_2ND)
      string = '(n,2nd)'
    case (N_2N)
      string = '(n,2n)'
    case (N_3N)
      string = '(n,3n)'
    case (N_FISSION)
      string = '(n,fission)'
    case (N_F)
      string = '(n,f)'
    case (N_NF)
      string = '(n,nf)'
    case (N_2NF)
      string = '(n,2nf)'
    case (N_NA)
      string = '(n,na)'
    case (N_N3A)
      string = '(n,n3a)'
    case (N_2NA)
      string = '(n,2na)'
    case (N_3NA)
      string = '(n,3na)'
    case (N_NP)
      string = '(n,np)'
    case (N_N2A)
      string = '(n,n2a)'
    case (N_2N2A)
      string = '(n,2n2a)'
    case (N_ND)
      string = '(n,nd)'
    case (N_NT)
      string = '(n,nt)'
    case (N_N3HE)
      string = '(n,nHe-3)'
    case (N_ND2A)
      string = '(n,nd2a)'
    case (N_NT2A)
      string = '(n,nt2a)'
    case (N_4N)
      string = '(n,4n)'
    case (N_3NF)
      string = '(n,3nf)'
    case (N_2NP)
      string = '(n,2np)'
    case (N_3NP)
      string = '(n,3np)'
    case (N_N2P)
      string = '(n,n2p)'
    case (N_NPA)
      string = '(n,npa)'
    case (N_N1 : N_N40)
      string = '(n,n' // trim(to_str(MT-50)) // ')'
    case (N_NC)
      string = '(n,nc)'
    case (N_DISAPPEAR)
      string = '(n,disappear)'
    case (N_GAMMA)
      string = '(n,gamma)'
    case (N_P)
      string = '(n,p)'
    case (N_D)
      string = '(n,d)'
    case (N_T)
      string = '(n,t)'
    case (N_3HE)
      string = '(n,3He)'
    case (N_A)
      string = '(n,a)'
    case (N_2A)
      string = '(n,2a)'
    case (N_3A)
      string = '(n,3a)'
    case (N_2P)
      string = '(n,2p)'
    case (N_PA)
      string = '(n,pa)'
    case (N_T2A)
      string = '(n,t2a)'
    case (N_D2A)
      string = '(n,d2a)'
    case (N_PD)
      string = '(n,pd)'
    case (N_PT)
      string = '(n,pt)'
    case (N_DA)
      string = '(n,da)'
    case (201)
      string = '(n,Xn)'
    case (202)
      string = '(n,Xgamma)'
    case (203)
      string = '(n,Xp)'
    case (204)
      string = '(n,Xd)'
    case (205)
      string = '(n,Xt)'
    case (206)
      string = '(n,X3He)'
    case (207)
      string = '(n,Xa)'
    case (444)
      string = '(damage)'
    case (COHERENT)
      string = 'coherent scatter'
    case (INCOHERENT)
      string = 'incoherent scatter'
    case (PAIR_PROD_ELEC)
      string = 'pair production, electron'
    case (PAIR_PROD)
      string = 'pair production'
    case (PAIR_PROD_NUC)
      string = 'pair production, nuclear'
    case (PHOTOELECTRIC)
      string = 'photoelectric'
    case (534 : 572)
      string = 'photoelectric, ' // trim(SUBSHELLS(MT - 533)) // ' subshell'
    case (600 : 648)
      string = '(n,p' // trim(to_str(MT-600)) // ')'
    case (649)
      string = '(n,pc)'
    case (650 : 698)
      string = '(n,d' // trim(to_str(MT-650)) // ')'
    case (699)
      string = '(n,dc)'
    case (700 : 748)
      string = '(n,t' // trim(to_str(MT-700)) // ')'
    case (749)
      string = '(n,tc)'
    case (750 : 798)
      string = '(n,3He' // trim(to_str(MT-750)) // ')'
    case (799)
      string = '(n,3Hec)'
    case (800 : 848)
      string = '(n,a' // trim(to_str(MT-800)) // ')'
    case (849)
      string = '(n,ac)'
    case default
      string = 'MT=' // trim(to_str(MT))
    end select

  end function reaction_name

!===============================================================================
! IS_FISSION determines if a given MT number is that of a fission event. This
! accounts for aggregate fission (MT=18) as well as partial fission reactions.
!===============================================================================

  function is_fission(MT) result(fission_event)

    integer, intent(in) :: MT
    logical             :: fission_event

    if (MT == N_FISSION .or. MT == N_F .or. MT == N_NF .or. MT == N_2NF &
         .or. MT == N_3NF) then
      fission_event = .true.
    else
      fission_event = .false.
    end if

  end function is_fission

!===============================================================================
! IS_DISAPPEARANCE determines if a given MT number is that of a disappearance
! reaction, i.e. a reaction with no neutron in the exit channel
!===============================================================================

  function is_disappearance(MT) result(dis)

    integer, intent(in) :: MT
    logical             :: dis

    if (MT >= N_DISAPPEAR .and. MT <= N_DA) then
      dis = .true.
    elseif (MT >= N_P0 .and. MT <= N_AC) then
      dis = .true.
    elseif (any(MT == [N_TA, N_DT, N_P3HE, N_D3HE, N_3HEA, N_3P])) then
      dis = .true.
    else
      dis = .false.
    end if

  end function is_disappearance

!===============================================================================
! IS_INELASTIC_SCATTER determines if a given MT number is that of an inelastic
! scattering event
!===============================================================================

  function is_inelastic_scatter(MT) result(retval)

    integer, intent(in) :: MT
    logical             :: retval

    if (MT < 100) then
      if (is_fission(MT)) then
        retval = .false.
      else
        retval  = (MT >= MISC .and. MT /= 27)
      end if
    elseif (MT <= 200) then
      retval = (.not. is_disappearance(MT))
    else
      retval = .false.
    end if

  end function

end module endf
