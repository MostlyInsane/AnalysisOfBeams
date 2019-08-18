% Author: Nikhil Dandamudi
% Created: 2019-08-09

function retval = AnalysisOfBeams (Input)
 %---------------------------------------------------  
  disp("");
  disp("                   $$$ Start Of Analysis $$$                         ");  
  disp("********************************************************************");
  disp("                           STEP 1:                                   "); 
  disp("********************************************************************");
 
  disp("Fixed End Moments Are As Follows :");
  
  FixedEndMoment(Input)
  
  disp("********************************************************************");
  disp("                           STEP 2:                                   "); 
 %--------------------------------------------------- 
  disp("********************************************************************");
  
  disp("Distribution Factor Are As Follows :");
  
  DistributionFactor(Input)
  
  disp("********************************************************************");
  disp("                          STEP 3:                                   "); 
  %--------------------------------------------------- 
  disp("********************************************************************");
   
  disp("Iterative Process Of Moment Distribution Is As Follows :");
  
  MomentDistributionMatrix = MomentDistribution (Input,FixedEndMoment(Input), DistributionFactor(Input))
  
  disp("====================================================================");
  sum(MomentDistributionMatrix)
  disp("====================================================================");
  
  disp("");
  
  disp("********************************************************************");
  disp("                             BMD:                                   "); 
  %---------------------------------------------------
  disp("********************************************************************");
  
  SpanMatrix=[0];
  temp=size(Input);
  temp1=size(SpanMatrix);
 
  for i=1:temp(1) ,
      
    SpanMatrix=[SpanMatrix , SpanMatrix(temp1(2))+Input(i,8)];
    temp1=size(SpanMatrix);
    
  end
  
  disp("Plotting BENDING MOMENT DIAGRAM :");
  disp("");
  
  BMD( MomentDistributionMatrix , SpanMatrix , Input ); 
  
  disp("********************************************************************");
  disp("                     $$ End Of Analysis $$$                         ")
  
  %---------------------------------------------------
  
end
