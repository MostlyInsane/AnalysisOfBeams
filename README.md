*ANALYSIS OF BEAMS.M*:

The AnalysisOfBeams function is just something like a CLUI of the final output, it does nothing more than call the appropriate function

     Syntax : AnalysisOfBeams (Input, LeftSupport , TypeOfAnalysis) 
      
        *INPUT= 
           Direct Input : Where, Input is provided from an excel sheet with respective coloumns with their properties, and rows grow as
                          number of spans increase. ( Preffered Units : KN and M )
                          
                          Important Note : NOT REQUIRED TO MENTION THE SIGN OR ANYTHING JUST MENTION THE MAGNITUDE OF SINKING (same units)
                          
           Indirect Input : If Sinking is present in the given structure, please mention 'The Youngs Modulus (E)' And 'Area Moment Of 
                            Inertia (I)' in the line 64 & 65 respectively of FixedEndMoment.m function. (Preffered units KN/M^2 AND M^4)
         
         
        *LEFT SUPPORT= There is no option in the Excel to take input for the TYPE OF left most support, hence type is given in the second
         parameter.
           where,
           0=Discontinuous Support.
           1=Continuous Support.
           2=Overhanging Support.
           
        *TypeOfAnalysis= as the name suggests, what mode of analysis
           where,
           0= Continuous Beam Analysis / Non Sway Type Analysis.
           1= Pure Right Sway Analysis.
          -1= Pure Left Sway Analysis.
           2= General Sway Type Analysis.
         NOTE: Rigid Frame Analysis Is Not Yet Supported.
         
         *VERY VERY IMPORTANT NOTE : In pure sway type analysis and general sway type analysis the accuracy depends on the magnitude of
                                     INITIAL assumed moments, so it is preferred that you chnage the Multiplication Factor to some other
                                     number ( From *11.842 ) in line 89 of MomentDistribution.m Function ONLY IF ACCEPTED ERROR > 0.1.
                                     
                                     
         
