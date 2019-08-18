% Author: Nikhil Dandamudi
% Created: 2019-08-09

function MomentDistributionMatrix = MomentDistribution (InputMatrix, FixedEndMomentMatrix, DistributionFactorMatrix)
  
  j=1;
  
%%Inputing Values of Exiting Moment Into Matrix :
  temp=size(InputMatrix);
  for i=1:(temp(1)*2)                           
    if(rem(i,2)~= 0) ,

      MomentDistributionMatrix(1,i)=FixedEndMomentMatrix(j,1);

    else ,

      MomentDistributionMatrix(1,i)=FixedEndMomentMatrix(j,2);
      j=j+1;
      
    end
    
  end
  
  EndCorrection=[0];
  %%MomentDistributionMatrix
  
%% END CORRECTION (IF ANY) :

  temp=size(InputMatrix);
  temp1=size(MomentDistributionMatrix);
  
  if ((InputMatrix(temp(1),2)==0) && (MomentDistributionMatrix (MomentDistributionMatrix(1,temp1(2))~=0))) ,

    Correction=0;
    Correction=MomentDistributionMatrix(1,temp1(2))*-1;
    MomentDistributionMatrix(1,temp1(2))=MomentDistributionMatrix(1,temp1(2)) + Correction;
    MomentDistributionMatrix(1,(temp1(2)-1))=(MomentDistributionMatrix(1,temp1(2)-1) + (Correction/2));
    EndCorrection=[1];
    
  end
  
  if (InputMatrix(temp(1),2)==2) , %%Overhanging Continuous Beam
    
    Correction=0;
    Correction=(MomentDistributionMatrix(1,temp1(2)-2)+MomentDistributionMatrix(1,temp1(2)-1))*-1;
    MomentDistributionMatrix(1,temp1(2)-2)=MomentDistributionMatrix(1,temp1(2)-2) + Correction;
    MomentDistributionMatrix(1,(temp1(2)-3))=(MomentDistributionMatrix(1,temp1(2)-3) + (Correction/2));
    EndCorrection=[1];
    
  end
  
  %%MomentDistributionMatrix
    
%% ITERATIVE PROCESS OF DISTRIBUTION THEORM:

   i=2;
   j=3;
   l=1;
   SumOfAccuracy= sum(abs(MomentDistributionMatrix'));
   NoOfIterations=length(MomentDistributionMatrix)/2-1;
   
   while (SumOfAccuracy(i-1) > (0.01)*(temp(1))) ,
     
     l=1;

     for k=1:NoOfIterations , %% Inputs elements into respective columns for a row
       
       ExternalMoment=(MomentDistributionMatrix(i-1,l+1)+MomentDistributionMatrix(i-1,l+2))*-1;
       %disp("Distributing")
       MomentDistributionMatrix(i,l+1)= DistributionFactorMatrix(l,1)*ExternalMoment;
       %disp("Carry Over To Left :")
       MomentDistributionMatrix(i+1,l)=MomentDistributionMatrix(i,l+1)/2; 
       %disp("Distributing")
       MomentDistributionMatrix(i,l+2)=DistributionFactorMatrix(l+1,1)*ExternalMoment;
       %disp("Carry Over To Right :")
       if(EndCorrection==1 && InputMatrix(temp(1),2)~=2) ,
 
         if ((k~=((temp(1)-2)*2)) && ((temp(1)>2))) ,
             
           MomentDistributionMatrix(i+1,l+3)=MomentDistributionMatrix(i,l+2)/2;
           
         elseif ((k~=((temp(1)-2)*2)) && ((temp(1)<=2))) ,
           
           MomentDistributionMatrix(i+1,l+3)=MomentDistributionMatrix(i,l+2)/2;
           
         end
         
       elseif(EndCorrection==1 && InputMatrix(temp(1),2)==2) ,
       
         if (k~=(((temp(1)-2)*2)-1)) , %%Maybe Not Generalised
           
           MomentDistributionMatrix(i+1,l+3)=MomentDistributionMatrix(i,l+2)/2;
           
         end
               
       else ,
       
         MomentDistributionMatrix(i+1,l+3)=MomentDistributionMatrix(i,l+2)/2;
       
       end 
     
       if (InputMatrix(temp(1),2)==2 && temp(1)<=3 ),
         
           break;
 
       end
       
       if (temp(1)<= 2),
         
         break;
         
       end
          
       l=l+2;
       
     end 
     
     if (InputMatrix(temp(1),2)==2 && temp(1)<=3 ),
         
           break;
 
     end
     
     if(temp(1)<=2),
     
       break;
       
     end
     
     SumOfAccuracy= sum(abs(MomentDistributionMatrix'));   
     i=i+2;
     
     %MomentDistributionMatrix=(round(MomentDistributionMatrix.*100))/100;
     
     end
     
   end
   
