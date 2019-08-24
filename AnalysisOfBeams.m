% Author: Nikhil Dandamudi
% Created: 2019-08-09

function retval = AnalysisOfBeams (Input, LeftSupport , TypeOfAnalysis)
 %--------------------------------------------------- 
  disp("");
  disp("                   $$$ Start Of Analysis $$$                         ");  
  disp("");
  
  if ( TypeOfAnalysis == 0) 
      
     disp("           ANALYSIS TYPE: CONTINUOUS BEAM ANALYSIS                          "); 
     
  end
  
  if ( TypeOfAnalysis == 1 || TypeOfAnalysis == -1 )
      
     disp("           ANALYSIS TYPE: PURE SWAY TYPE 'FRAME' ANALYSIS                     ");
     
  end
  
  if ( TypeOfAnalysis == 2) 
      
     disp("           ANALYSIS TYPE: GENERAL SWAY TYPE 'FRAME' ANALYSIS                    ");
     
  end
  
  disp("********************************************************************");
  disp("                           STEP 1:                                   "); 
  disp("********************************************************************");
 
  disp("Fixed End Moments Are As Follows :");
  
  temp=size(Input);
         %--------------------------------------------------------------------------------------
  %Begin Of Sinking Correction :    
      
  if ( TypeOfAnalysis == -1 )  %Sinking Correction For Suited To Left Pure Sway Analysis
          
        for i=1:temp 
              
           if ( i ~= temp )
               
              Input(i,9)= -1;
              
           else
               
              Input(i,9)= -2;
                 
           end
              
        end
          
  end
      
  if ( TypeOfAnalysis == 1 )  %Sinking Correction For Suited To Right Pure Sway Analysis
          
         for i=1:temp 
              
           if ( i ~= temp )
               
              Input(i,9)= 1;
              
           else
               
              Input(i,9)= 2;
                 
           end
              
         end
          
  end
   
      
   %End Of Sinking Correction.  
   
          %--------------------------------------------------------------------------------------
  
  FixedEndMoment(Input)
  
  disp("********************************************************************");
  disp("                           STEP 2:                                   "); 
 %--------------------------------------------------- 
  disp("********************************************************************");
  
  disp("Distribution Factor Are As Follows :");
  
  DistributionFactor(Input,LeftSupport)
  
  disp("********************************************************************");
  disp("                          STEP 3:                                   "); 
  %--------------------------------------------------- 
  disp("********************************************************************");
  
  %ANALYSIS OF CONTINUOUS BEAM :
  
  if (TypeOfAnalysis == 0)  
   
    disp("Iterative Process Of Moment Distribution Is As Follows :");
  
    MomentDistributionMatrix = MomentDistribution (Input,FixedEndMoment(Input), DistributionFactor(Input,LeftSupport) , LeftSupport )
  
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
    
  end
  
  %ANALYSIS OF PURE SWAY TYPE OF FRAMES :
  
  if (TypeOfAnalysis == -1 || TypeOfAnalysis== 1) % -1= Pure Left Sway Frame Analysis , +1= Pure Right Sway Frame Analysis 
      
      
      disp("Iterative Process Of Moment Distribution Is As Follows :");
      disp("Uncorrected MomentDistributionMatrix is ");
      
      MomentDistributionMatrix = MomentDistribution (Input,FixedEndMoment(Input), DistributionFactor(Input,LeftSupport) , LeftSupport )
      
      disp("====================================================================");
      UncorrectedMoment=sum(MomentDistributionMatrix)
      disp("====================================================================");
      
      disp("")
      disp("Factor By Which The Assumed Moment To Be Multiplied is :");
      disp("");
      
      Factor = FactorOfMultiplication( MomentDistributionMatrix , Input ) 
      disp("");

      disp("Sum Of Corrected MomentDistributionMatrix is ");
      disp("")
      
      disp("====================================================================");
      CorrectedMoment=UncorrectedMoment.*Factor
      disp("====================================================================");
      
  
      disp("********************************************************************");
  
             
  end
  
  if (TypeOfAnalysis == 2) %General Sway Type Frame Analysis
    
    disp("                        STEP A :                                   ");
    disp("~~~~~~~~~~~Considering NON SWAY TYPE ANALYSIS :~~~~~~~~~~~~~~~~~~~" );
    disp("");
    disp("Iterative Process Of Moment Distribution Is As Follows :");
  
    MomentDistributionMatrix = MomentDistribution (Input,FixedEndMoment(Input), DistributionFactor(Input,LeftSupport) , LeftSupport )
  
    disp("====================================================================");
    NonSwayMoment=sum(MomentDistributionMatrix)
    disp("====================================================================");
  
    disp("");
    
    %--------------------------------FINDING SWAY FORCE----------------------------------------------------------
    
   MomentDistributionMatrix = sum ( MomentDistributionMatrix)
   temp2=size(MomentDistributionMatrix);
       
   HorizontalForce = (MomentDistributionMatrix(1,1)+ MomentDistributionMatrix(1,2)) / Input(1,8);
   HorizontalForce = [ HorizontalForce , (MomentDistributionMatrix(1,temp2(2)-1)+ MomentDistributionMatrix(1,temp2(2))) / Input(temp(1),8) ];
   SwayForce=sum(HorizontalForce');
   
    %-----------------------------------------------------------------------------------------------------------
    
    disp("                        STEP B :                                   ")
    disp("~~~~~~~~~~~Considering PURE SWAY TYPE ANALYSIS :~~~~~~~~~~~~~~~~~~~" );
    
    %---------------------------------------Inserting Sway Force  ----------------------------------------------
    
    Input(1,1)=SwayForce;
    Input(1,3)=0;
    
    for i=2:temp
        
        Input(i,1)=0;
        Input(i,3)=0;
        
    end
    
    %-----------------------------------------------------------------------------------------------------------
    
    %---------------------------Correction For Sinking Suited To General Sway-----------------------------------
          
    for i=1:temp 
              
      if ( i ~= temp )
               
        Input(i,9)= 1;
              
      else
               
        Input(i,9)= 2;
                 
      end
              
    end
    
    %---------------------------------------------------------------------------------------------------------
    
    disp("Iterative Process Of Moment Distribution Is As Follows :");
    disp("Uncorrected MomentDistributionMatrix is ");
     
    MomentDistributionMatrix = MomentDistribution (Input,FixedEndMoment(Input), DistributionFactor(Input,LeftSupport) , LeftSupport )
      
    disp("====================================================================");
    UncorrectedMoment=sum(MomentDistributionMatrix)
    disp("====================================================================");
      
    disp("")
    disp("Factor By Which The Assumed Moment To Be Multiplied is :");
    disp("");
      
    Factor = FactorOfMultiplication( MomentDistributionMatrix , Input ) 
    disp("");

    disp("Sum Of Corrected MomentDistributionMatrix is ");
    disp("")
      
    disp("====================================================================");
    PureSwayMoment=UncorrectedMoment.*Factor
    disp("====================================================================");
      
  
    disp("Total Corrected Moment Acting On The Given GENERAL SWAY TYPE FRAME Is : (NON SWAY MOMENT + PURE SWAY MOMENT ");
    
    NonSwayMoment
    PureSwayMoment
    disp("====================================================================")
    GeneralSwayMoment=NonSwayMoment+PureSwayMoment
    disp("====================================================================")
         
  end
  
  disp("********************************************************************");
  disp("                     $$ End Of Analysis $$$                         ")
  
  %---------------------------------------------------
  
end
