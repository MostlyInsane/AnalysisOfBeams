% Author: Nikhil Dandamudi
% Created: 2019-08-12

function InternalResistingMoment = BMD ( MomentDistributionMatrix , SpanMatrix ,Input)
  
  InternalResistingMoment = sum( MomentDistributionMatrix );
  InternalResistingMoment;
  temp = size(Input);
  
  for i=1:(length(InternalResistingMoment)-length(SpanMatrix)) ,
    
    InternalResistingMoment(2*i)=[];
    
  end
   
   PlotMatrix=SpanMatrix;
   j=1;
% Possibility Of Error
   for i=1:temp(1) ,
     
     if( Input(i,2)==1 && (Input(i,6)-Input(i,5))==Input(i,8)) , %%UniformDistributedLoad
    
       ExternalLoadMomentMatrix(1,j)=(Input(i,3)*(Input(i,8)^2))/8;
       ExternalLoadMomentMatrix(1,j+1)=0;
       PlotMatrix=[PlotMatrix,SpanMatrix(i)+((Input(i,6)-Input(i,5))/2)];
       j=j+2;
       
     else , %%Point Load

       ExternalLoadMomentMatrix(1,j)=(Input(i,1)*(Input(i,8)-Input(i,4))*Input(i,4))/Input(i,8);
       ExternalLoadMomentMatrix(1,j+1)=0;
       PlotMatrix=[PlotMatrix,SpanMatrix(i)+Input(i,4)];
       j=j+2;
       
     end
     
   end
    
  PlotMatrix=sort(PlotMatrix);
  ExternalLoadMomentMatrix=[0,ExternalLoadMomentMatrix];
  %InternalResistingMoment
  disp("PLOT VALUES OF INTERNAL RESISTING MOMENT : ");
  disp("     X-axis     Y-Axis");
  [SpanMatrix',InternalResistingMoment']
  plot(SpanMatrix,abs(InternalResistingMoment));
  hold on;
  j=1;
  %PlotMatrix
  %ExternalLoadMomentMatrix
  for i=1:temp(1) ,
    
    if (Input(i,3)~=0), %% Variation Should Be Parabolic For The Given Span
      
      QuadarticCoefficient=polyfit(PlotMatrix(j:2+j),ExternalLoadMomentMatrix(j:2+j),2);
      PlotMatrixX=linspace(PlotMatrix(j),PlotMatrix(2+j));
      plot(PlotMatrixX,(QuadarticCoefficient(1)*(PlotMatrixX.^2)+QuadarticCoefficient(2)*(PlotMatrixX)+QuadarticCoefficient(3)));
      hold on;
      j=j+2;
      
    else
      
      plot(PlotMatrix(j:j+2),ExternalLoadMomentMatrix(j:j+2));
      hold on;
      j=j+2;
      
    end
    
  end
  
   disp("PLOT VALUES Of FREE MOMENT / (DUE TO EXTERNAL LOADING : ");
   disp("     X-axis     Y-Axis");
   [PlotMatrix',ExternalLoadMomentMatrix']

end
