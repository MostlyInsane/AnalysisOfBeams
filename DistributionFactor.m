%% Author: Nikhil Dandamudi
%% Created: 2019-08-08

function DistributionFactorMatrix = DistributionFactor (Input)
  i=1;
  k=1;
  l=1;
  for j=1:size(Input)(1) ,
    
    if ( (j < size(Input)(1)) && (Input(j+1,2)~=2)) , %% Continuous Support or Support Which Can Offer Moment Except OverHangingBeam

      DistributionFactorMatrix(i,1)=(Input(j,7)/Input(j,8));
      i=i+1;
      
      if((j+1)<size(Input)(1) && (Input(j+2,2)~=2) ) ,  
      
        DistributionFactorMatrix(i,1)=(Input(j+1,7)/Input(j+1,8));
        i=i+1;
        
      endif
      
    elseif ( Input(size(Input)(1),2)== 0 || Input(size(Input)(1),2)== 2 ) , %% Discontinuous Support
      
      DistributionFactorMatrix(i,1)=(3/4)*(Input(j,7)/Input(j,8));
      break;
      
    elseif ( Input(size(Input)(1),2)== 1 ) , %% Continuous Support
      
      DistributionFactorMatrix(i,1)=(Input(j,7)/Input(j,8));   
      
    endif
    
  end
  
  while (l<=(length(DistributionFactorMatrix)/2)) ,
    Sum=DistributionFactorMatrix(k,1)+DistributionFactorMatrix(k+1,1);
    DistributionFactorMatrix(k,1)=DistributionFactorMatrix(k,1)/Sum;
    DistributionFactorMatrix(k+1,1)=DistributionFactorMatrix(k+1,1)/Sum;
    k=k+2;
    l=l+1;
  end

  DistributionFactorMatrix=(round(DistributionFactorMatrix.*100))/100;

endfunction