

class RoleAccessState {
  final int? revenueGenerated;
 

  RoleAccessState({
    this.revenueGenerated = 0,
   
  });

  RoleAccessState copyWith({
    int? revenueGenerated,
    
  }) =>
      RoleAccessState(
        revenueGenerated: revenueGenerated ?? this.revenueGenerated,
       
      );
}
