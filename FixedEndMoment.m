% Author: Nikhil Dandamudi
% Created: 2019-08-08

function FEM = FixedEndMoment (Input)
  temp=size(Input);
  for i=1:temp(1) , %Due to External Load
    
    if (Input(i,3)~=0) , %UniformDistributedLoad
      
      FEM(i,1)=(-1*(Input(i,3)*Input(i,8)^2)/12);
      FEM(i,2)=(Input(i,3)*Input(i,8)^2)/12;
  
    else  %PointLoad
    
      FEM(i,1)=-1*(Input(i,1)*Input(i,4)*(Input(i,8)-Input(i,4))^2)/(Input(i,8)^2);
      FEM(i,2)=(Input(i,1)*(Input(i,4)^2)*(Input(i,8)-Input(i,4)))/(Input(i,8)^2);
      
    end
    
  end  
  
  temp1=size(FEM);
  
  if (Input(temp(1),2)==2) , %Overhanging Continuous Beam"

    if(Input(temp(1),3)~=0) ,  %UniformDistributedLoad
    
      FEM(temp1(1),1)=-Input(temp(1),1)*Input(temp(1),8);
      FEM(temp1(1),2)=0;
      
    else                              %PointLoad
      
      FEM(temp1(1),1)=-Input(temp(1),1)*Input(temp(1),8);
      FEM(temp1(1),2)=0;
      
    end
    
  end
  
 %CORRECTION DUE TO SINKING :
 
  SinkLeftEnd=0;
  SinkRightEnd=0;
  E=200000000;
  I=0.000004;
  
   %FIRST SPAN CORRECTION
   
  Correction=-1*((6*E*Input(1,7)*I*(Input(1,9)-SinkLeftEnd))/(Input(1,8)^2));
  FEM(1,1)=FEM(1,1)+Correction;
  FEM(1,2)=FEM(1,2)+Correction;
  
  for i=2:temp(1)-1 , %MIDDLE SPAN CORRECTION'S

      Correction=-1*((6*E*Input(i,7)*I*(Input(i,9)-Input(i-1,9)))/(Input(i,8)^2));
      FEM(i,1)=FEM(i,1)+Correction;
      FEM(i,2)=FEM(i,2)+Correction;  
     
  end
  
   %LAST SPAN CORRECTION
  if( Input(temp(1),2) ~= 2) ,
         
    Correction=0;
    Correction=-1*((6*E*Input(temp(1),7)*I*(SinkRightEnd-Input(temp(1)-1,9))/(Input(temp(1),8)^2)));
    FEM(temp(1),1)=FEM(temp(1),1)+Correction;
    FEM(temp(1),2)=FEM(temp(1),2)+Correction;
  
  end
  
end
