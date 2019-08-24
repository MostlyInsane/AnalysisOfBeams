% Author: Nikhil Dandamudi
% Created: 2019-08-24


function Factor = FactorOfMultiplication( MomentDistributionMatrix , Input )

   MomentDistributionMatrix = sum ( MomentDistributionMatrix);
   temp1=size(MomentDistributionMatrix);
   temp=size(Input);
       
   HorizontalForce = (MomentDistributionMatrix(1,1)+ MomentDistributionMatrix(1,2)) / Input(1,8);
   HorizontalForce = [ HorizontalForce , (MomentDistributionMatrix(1,temp1(2)-1)+ MomentDistributionMatrix(1,temp1(2))) / Input(temp(1),8) ];
   TotalHorForce=sum(HorizontalForce');
   temp=sum(Input);
   Factor=abs((temp(1,1)/TotalHorForce));
  
end

