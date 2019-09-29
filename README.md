**DOCUMENTATION OF ANALYSIS OF BEAMS USING MDM : (MATLAB/OCTAVE)**

**Author : *Nikhil Dandamudi* **

**ANALYSIS OF BEAMS.M ( All there is to know on how to run the program ): // ONLY FUNCTION REQUIRED TO GET THE OUTPUT**

The AnalysisOfBeams function is just something like a CLUI of the final output, it does nothing more than call the appropriate function

     Syntax : AnalysisOfBeams (Input, LeftSupport , TypeOfAnalysis) 
      
        *INPUT= 
           Direct Input : Where, Input is provided from an excel sheet with respective coloumns with their properties, and rows grow as
                          number of spans increase. ( Preffered Units : KN and M )
                          
                          Important Note : Input is read using xlsread('//path')
                                             Example : xlsread('C:\Users\MONSTERRRRR PC!!!!\Desktop\MDM\Input.xlsx').
                          
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
           0= Continuous Beam Analysis / Non Sway Type Analysis (Portal Frame).
           1= Pure Right Sway Analysis.   (Portal Frame)
          -1= Pure Left Sway Analysis.    (Portal Frame)
           2= General Sway Type Analysis. (Portal Frame)
         NOTE: Rigid Frame Analysis Is Not Yet Supported.
         
         *VERY VERY IMPORTANT NOTE : In pure sway type analysis and general sway type analysis the accuracy depends on the magnitude of
                                     INITIAL assumed moments, so it is preferred that you chnage the Multiplication Factor to some other
                                     number ( From *11.842 ) in line 89 of MomentDistribution.m Function ONLY IF ACCEPTED ERROR > 0.1.
   
   
**FixedEndMoment.m : ( Just to know how this function works and what it does !! ) :** 

The FixedEndMoment.m just calculates the FixedEndMoments after assuming all the supports as Fixed, IT HAS TO BE NOTED THAT END
CORRECTION IS NOT INCLUDED IN THIS FUNCTION, RATHER IT IS INCLUDED IN MomentDistribution.m FUNCTION

     Syntax : FixedEndMoment (Input,LeftSupport)
              Input, LeftSupport follow same nomenclature and method given in AnalysisOfBeams.m 
          
          
**DistributionFactor.m : ( Just to know how this function works and what it does !! ) :** 

The DistributionFactor.m just calculates the Distribution Factors after assuming all the 'Intermediate' supports as Fixed.

     Syntax : DistributionFactor (Input , LeftSupport)
              where parameteres,
              Input : Is InputData From Excel sheet.
              LeftSupport : Same Nomenclature as used in AnalysisOfBeams.m Function.
              
              
**MomentDistribution.m : ( Just to know how this function works and what it does !! ) :**

The *MomentDistribution.m* just distributes the moments based on the distribution factor and applies end correction for discontinuous
supports / left overhanging / right overhanging. 
Note: Seems To be a bit buggy when OverHanging On BOTH SIDES ( i.e "SIMULTANEOUSLY" ), will fix it in the next update.

     Syntax : MomentDistribution (InputMatrix, FixedEndMomentMatrix, DistributionFactorMatrix , LeftSupport , IsPureSway)
                 where parameters,
                 InputMatrix : Is InputData From Excel sheet.
                 FixedEndMomentMatrix : Matrix that is returned from FixedEndMoment.m function.
                 DistributionFactorMatrix : Matrix that is returned from DistributionFactor.m function.
                 LeftSupport : Same Nomenclature as used in AnalysisOfBeams.m Function.
                 IsPureSway : Whether Pure Sway Analysis is used anywhere or not. ( Right now has no Purpose, in further update will 
                                                                                    remove the manual entry to increase accuracy as
                                                                                    described in VERY VERY IMPORTANT NOTE )
                              0= If not used.
                              1= If Used.
                              
                              
**BMD.m :  ( Just to know how this function works and what it does !! ) :**

This Function Plots The Bending Moment Diagram For Any Given CONTINUOUS SPAN BEAM , BMD for portal frames and rigid frames is not yet 
supported.

     Syntax : BMD ( MomentDistributionMatrix , SpanMatrix ,Input)
                 where parameters,
                 MomentDistributionMatrix = Matrix that is returned from MomentDistribution.m function. 
                 SpanMatrix= Row Matrix of 'increasing span distance'.
                 Input : Is InputData From Excel sheet.
          
                              
**FactorOfMultiplication.m :  ( Just to know how this function works and what it does !! ) :** 

This Function just corrects the Assumed Moments in PURE SWAY ANALYSIS / GENERAL SWAY ANALYSIS OF PORTAL FRAME.

     Syntax : FactorOfMultiplication( MomentDistributionMatrix , Input )
                 where parameters, 
                 MomentDistributionMatrix = Matrix that is returned from MomentDistribution.m function. 
                 Input : Is InputData From Excel sheet.

                              
