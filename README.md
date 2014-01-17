EmbryoTracker

usage:

    run the full tracking using
   
    runTracker(dirin, dirout)
  
    see runTracker.m for details and to set parameter
    see loadEmbryoDataFrame.m to set parameter for loading the data


algorithm:
    
   traking is done by matching objects in subsequent frames using
   a cost matrix formalism and then determining the trajectories
   
  
code:
   
 Files
   costMatchMatrix          - cost = costMatchMatrix(data, matches)
   costMatrix               - cost = costMatrix(data0, data1, creation_cost, deletion_cost, dist_cutoff)
   costTrajectoryMatrix     - cost = costTrajectoryMatrix(data, traj)
   distanceMatrix           - dist = distanceMatrix(data0, data1)
   estimateDistanceCutoff   - dist = estimateDistanceCutoff(data0, data1)
   estimateNonLinkingCost   - dist = estimateNonLinkingCost(data0, data1)
   loadEmbryoData           - data = loadEmbryoData(dir)
   loadEmbryoDataFrame      - data = loadEmbryoDataFrame(fn)
   matchAllFrames           - [match, cost] = matchAllFrames(data, creation_cost, deletion_cost, dist_cutoff)
   matchedCoordinates       - [X0, X1] = matchedCoordinates(data0, data1, match)
   matchedPairs             - pairs = matchedPairs(match, k)
   matchedStatistics        - stat = matchedStatistics(data0, data1, cost, match)
   matchedTrajectories      - [traj, times] = matchedTrajectories(matches, nfinal)
   matchFrames              - match = matchFrames(data0, data1, creation_cost, deletion_cost, dist_cutoff)
   optimalAssociationMatrix - result = optimalAssociationMatrix(A, cost)
   optimalTransformation    - [R, T, C] = optimalTransformation(X, Y)
   optimizedMatchFrames     - match = optimizedMatchFrames(data0, data1)
   plotMatchedCostMatrix    - plotMatchedCostMatrix(cost, match)
   plotMatchedTimeFrameData - plot result of matching
   plotMatchedTrajectories  - plotMatchedTimeFrameData(data, traj)
   plotTimeFrameData        - plot data in a time frame
   runTracker               - runTracker(indir, outdir, print, filter)
   saveEmbryoData           - saveEmbryoData(dirname, data, traj)
   trackingCost             - compute cost for the match
   TrackingMatchData        - TrackingMatchData(match, k) class storing data from matching two frames
   TrackingObjectData       - TrackingObjectData(x, d, varargin) class storing info for the objects to be tracked
   TrackingTimeFrameData    - class holding all objects to track in a certain time frame
   TrackingTrajectoryData   - TrackingTrajectoryData(times, ids) class storing trajectories
   trajectoryStatistics     - stat = trajectoryStatistics(data, traj)
   writeCSV                 - success = writeCSV(filename, data, header)
   
   