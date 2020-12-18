#!/bin/bash

tags=L1TK_MTC_truncated
numEvents=500

##Runs All seeds

for iSeed in {0..11..1}
  do
    echo Running on seed $iSeed
    sed -i "s/fileName = cms.string(.*),/fileName = cms.string('RelValTTbar_${numEvents}events_seed${iSeed}_${tags}'+'.root'),/" L1Trigger/TrackFindingTracklet/test/L1TrackNtupleMaker_cfg.py
    sed -i "s/useseeding_{.*};/useseeding_{$iSeed};/" L1Trigger/TrackFindingTracklet/interface/Settings.h
    echo Compiling....
    scram b -j4
    cd L1Trigger/TrackFindingTracklet/test/
    echo Begin Run! Seed $iSeed
    cmsRun L1TrackNtupleMaker_cfg.py
    sleep 5
    cd $CMSSW_BASE/src
    echo Finished running seed ${iSeed}.
  done

sed -i "s/useseeding_{.*}/useseeding_{0,1,2,3,4,5,6,7,8,9,10,11}/" L1Trigger/TrackFindingTracklet/interface/Settings.h
sed -i "s/fileName = cms.string(.*),/fileName = cms.string('RelValTTbar_500events_${tags}'+'.root'),/" L1Trigger/TrackFindingTracklet/test/L1TrackNtupleMaker_cfg.py
sed -i "s/(input = cms.untracked.int32(.*))/(input = cms.untracked.int32(-1))/" L1Trigger/TrackFindingTracklet/test/L1TrackNtupleMaker_cfg.py
scram b -j4
