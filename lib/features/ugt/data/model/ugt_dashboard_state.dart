
class UgtDashboardState {
  final int? revenueGenerated;
  final int? totalContestants;
  final int? contestStageCount;

  UgtDashboardState({
    this.revenueGenerated = 0,
    this.totalContestants = 0,
    this.contestStageCount = 0,
   
     

    
  
  });

  UgtDashboardState copyWith({
   int? revenueGenerated,
   int? totalContestants,
   int? contestStageCount,
  }) =>
      UgtDashboardState(
        revenueGenerated: revenueGenerated ?? this.revenueGenerated,
        totalContestants: totalContestants ?? this.totalContestants,
        contestStageCount: contestStageCount ?? this.contestStageCount,
      
      );
}