
###############################################################################
#
# Export variables to the default values
#  - first common variables, then model specific ones
#  - different machines, different defaults:
#
###############################################################################

if [ $MACHINE_ID = wcoss_cray ]; then

  TASKS_dflt=150 ; TPN_dflt=24 ; INPES_dflt=3 ; JNPES_dflt=8
  TASKS_thrd=84  ; TPN_thrd=12 ; INPES_thrd=3 ; JNPES_thrd=4

elif [ $MACHINE_ID = wcoss_dell_p3 ]; then

  TASKS_dflt=150 ; TPN_dflt=28 ; INPES_dflt=3 ; JNPES_dflt=8
  TASKS_thrd=84  ; TPN_thrd=14 ; INPES_thrd=3 ; JNPES_thrd=4

elif [[ $MACHINE_ID = orion.* ]]; then

  TASKS_dflt=150 ; TPN_dflt=24 ; INPES_dflt=3 ; JNPES_dflt=8
  TASKS_thrd=84  ; TPN_thrd=12 ; INPES_thrd=3 ; JNPES_thrd=4

  TASKS_cpl_dflt=154; TPN_cpl_dflt=40
  MPB_cpl_dflt="16 111"; APB_cpl_dflt="0 15"
  OPB_cpl_dflt="112 141"; IPB_cpl_dflt="142 153"

  TASKS_cpl_mx050=154; TPN_cpl_mx050=40
  MPB_cpl_mx050="16 111"; APB_cpl_mx050="0 15"
  OPB_cpl_mx050="112 141"; IPB_cpl_mx050="142 153"

  TASKS_cpl_mx025=280; TPN_cpl_mx025=40
  MPB_cpl_mx025="16 111"; APB_cpl_mx025="0 15"
  OPB_cpl_mx025="112 231"; IPB_cpl_mx025="232 279"

elif [[ $MACHINE_ID = hera.* ]]; then

  TASKS_dflt=150 ; TPN_dflt=40 ; INPES_dflt=3 ; JNPES_dflt=8
  TASKS_thrd=84  ; TPN_thrd=20 ; INPES_thrd=3 ; JNPES_thrd=4

  TASKS_cpl_dflt=154; TPN_cpl_dflt=40
  MPB_cpl_dflt="16 111"; APB_cpl_dflt="0 15"
  OPB_cpl_dflt="112 141"; IPB_cpl_dflt="142 153"

  TASKS_cpl_mx025=280; TPN_cpl_mx025=40
  MPB_cpl_mx025="16 111"; APB_cpl_mx025="0 15"
  OPB_cpl_mx025="112 231"; IPB_cpl_mx025="232 279"

elif [[ $MACHINE_ID = jet.* ]]; then

  TASKS_dflt=150 ; TPN_dflt=24 ; INPES_dflt=3 ; JNPES_dflt=8
  TASKS_thrd=84  ; TPN_thrd=12 ; INPES_thrd=3 ; JNPES_thrd=4

elif [[ $MACHINE_ID = gaea.* ]]; then

  TASKS_dflt=150 ; TPN_dflt=36 ; INPES_dflt=3 ; JNPES_dflt=8
  TASKS_thrd=84  ; TPN_thrd=18 ; INPES_thrd=3 ; JNPES_thrd=4

elif [[ $MACHINE_ID = cheyenne.* ]]; then

  TASKS_dflt=150 ; TPN_dflt=36 ; INPES_dflt=3 ; JNPES_dflt=8
  TASKS_thrd=84  ; TPN_thrd=18 ; INPES_thrd=3 ; JNPES_thrd=4

elif [[ $MACHINE_ID = stampede.* ]]; then

  TASKS_dflt=150 ; TPN_dflt=48 ; INPES_dflt=3 ; JNPES_dflt=8
  TASKS_thrd=84  ; TPN_thrd=24 ; INPES_thrd=3 ; JNPES_thrd=4

else

  echo "Unknown MACHINE_ID ${MACHINE_ID}"
  exit 1

fi

# Re-instantiate COMPILER in case it gets deleted by module purge
COMPILER=${NEMS_COMPILER:-intel}

# Longer default walltime for GNU and PGI
if [[ $COMPILER = gnu ]] || [[ $COMPILER = pgi ]]; then
    WLCLK_dflt=30
else
    WLCLK_dflt=30
fi

export_datm ()
{
export THRD=1
export WLCLK=$WLCLK_dflt
export TASKS=$TASKS_dflt
export TPN=$TPN_dflt
export RESTART_INTERVAL=0
export ENS_NUM=1

export SYEAR='2011'
export SMONTH='10'
export SDAY='01'
export SHOUR='00'
export CDATE=${SYEAR}${SMONTH}${SDAY}${SHOUR}

export NFHOUT=6
export DAYS=0.041666666
export FHMAX=1
export FHMAX=${FHMAX:-`expr $DAYS \* 24`}
export DT_ATMOS=900
export ATMRES='C96'
}

export_cpl ()
{
export DAYS="1"
export FHMAX="24"
export FDIAG="6"
export WLCLK=30

# default datm/ocn/ice resolution
export DATM_SRC='CFSR'
export FILENAME_BASE='cfsr.'
export IATM='1760'
export JATM='880'

export OCNRES='100'
export ICERES='1.00'
export NX_GLB=360
export NY_GLB=320

#default resources
export TASKS=$TASKS_cpl_dflt
export TPN=$TPN_cpl_dflt

export med_petlist_bounds=$MPB_cpl_dflt
export atm_petlist_bounds=$APB_cpl_dflt
export ocn_petlist_bounds=$OPB_cpl_dflt
export ice_petlist_bounds=$IPB_cpl_dflt

# component and coupling timesteps
export DT_ATMOS='900'
export DT_CICE=${DT_ATMOS}
export DT_DYNAM_MOM6='1800'
export DT_THERM_MOM6='3600'
export CPL_SLOW=${DT_THERM_MOM6}
export CPL_FAST=${DT_ATMOS}

# nems.configure defaults
export NEMS_CONFIGURE="nems.configure.medcmeps_datm_ocn_ice.IN"
export med_model="nems"
export atm_model="datm"
export ocn_model="mom6"
export ice_model="cice6"

export coupling_interval_slow_sec=${CPL_SLOW}
export coupling_interval_fast_sec=${CPL_FAST}

export RESTART_H=${FHMAX}
export CPLMODE='nems_orig_data'
export cap_dbug_flag="0"
export use_coldstart="false"
export RUNTYPE='startup'

# DATM defaults
export INPUT_NML="input.mom6.nml.IN"

# MOM6 defaults; 1 degree
export MOM_INPUT=MOM_input_template_100
export MOM6_RESTART_SETTING='n'
export MOM6_RIVER_RUNOFF='False'
export FRUNOFF=""
export CHLCLIM="seawifs_1998-2006_smoothed_2X.nc"
# this must be set False for restart repro 
export MOM6_REPRO_LA='False'
# since CPL_SLOW is set to DT_THERM, this should be always be false 
export MOM6_THERMO_SPAN='False'
# no WW3
export MOM6_USE_WAVES='False'

# CICE6 defaults; 1 degree
export NPROC_ICE='12'
export MESHICE="mesh.mx${OCNRES}.nc"
export CICEGRID="grid_cice_NEMS_mx${OCNRES}.nc"
export CICEMASK="kmtu_cice_NEMS_mx${OCNRES}.nc"
export RUNID='unknown'
# set large; restart frequency now controlled by restart_n in nems.configure
export DUMPFREQ='d'
export DUMPFREQ_N=1000
export USE_RESTART_TIME='.false.'
export RESTART_EXT='.false'
# setting to true will allow Frazil FW and Salt to be
# included in fluxes sent to ocean
export FRAZIL_FWSALT='.true.'
# default to write CICE average history files
export CICE_HIST_AVG='.true.'

export RT20D=''
}
export_20d_run ()
{
export CNTRL_DIR=''
export CNTLMED_DIR=''
export LIST_FILES=''
}
