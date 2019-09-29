% Author: Nikhil Dandamudi
% Created: 2019-08-09

function MomentDistributionMatrix = MomentDistribution (InputMatrix, FixedEndMomentMatrix, DistributionFactorMatrix , LeftSupport , IsPureSway)
  
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
  
  if ( LeftSupport == 2)
      
      temp2=size(FixedEndMomentMatrix);
      temp1=size(MomentDistributionMatrix);
      MomentDistributionMatrix(1,(temp1(2)+1))=FixedEndMomentMatrix(temp2(1),1);
      MomentDistributionMatrix(1,temp1(2)+2)=FixedEndMomentMatrix(temp2(1),2);
  
  end
  
  RightEndCorrection=[0];
  LeftEndCorrection=[0];
  
  MomentDistributionMatrix;
  
%% END CORRECTION (IF ANY) :

  temp=size(InputMatrix);
  temp1=size(MomentDistributionMatrix);
  
  %RightEndCorrection
  
  if (InputMatrix(temp(1),2)==0) ,

    Correction=0;
    Correction=MomentDistributionMatrix(1,temp1(2))*-1;
    MomentDistributionMatrix(1,temp1(2))=MomentDistributionMatrix(1,temp1(2)) + Correction;
    MomentDistributionMatrix(1,(temp1(2)-1))=(MomentDistributionMatrix(1,temp1(2)-1) + (Correction/2));
    RightEndCorrection=[1];
    
  end
  
  if (InputMatrix(temp(1),2)==2) , %%LeftOverhanging Continuous Beam
    
    Correction=0;
    Correction=(MomentDistributionMatrix(1,temp1(2)-2)+MomentDistributionMatrix(1,temp1(2)-1))*-1;
    MomentDistributionMatrix(1,temp1(2)-2)=MomentDistributionMatrix(1,temp1(2)-2) + Correction;
    MomentDistributionMatrix(1,(temp1(2)-3))=(MomentDistributionMatrix(1,temp1(2)-3) + (Correction/2));
    RightEndCorrection=[1];
    
  end
  
  %LeftEndCorrection:
  
   if ( LeftSupport == 0 ) ,

    Correction=0;
    Correction=MomentDistributionMatrix(1,1)*-1;
    MomentDistributionMatrix(1,1)=MomentDistributionMatrix(1,1) + Correction;
    MomentDistributionMatrix(1,2)=(MomentDistributionMatrix(1,2) + (Correction/2));
    LeftEndCorrection=[1];
    
  end
  
  if ( LeftSupport == 2) , %%LeftOverhanging Continuous Beam
    
    Correction=0;
    Correction=(MomentDistributionMatrix(1,2)+MomentDistributionMatrix(1,3))*-1;
    MomentDistributionMatrix(1,3)=MomentDistributionMatrix(1,3) + Correction;
    MomentDistributionMatrix(1,4)=(MomentDistributionMatrix(1,4) + (Correction/2));
    LeftEndCorrection=[1];
    
  end
  
  if( IsPureSway == 1 )
    
    MomentDistributionMatrix=MomentDistributionMatrix.*11.842;
    
  end
  
  %MomentDistributionMatrix;
  
    
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
       
       if(LeftEndCorrection==1 && LeftSupport~=2) ,

         if ((k~=1 && temp(1)>2)) ,
             
           MomentDistributionMatrix(i+1,l)=MomentDistributionMatrix(i,l+1)/2;
           
         elseif (k~=1 && temp(1)<=2) ,
           
           MomentDistributionMatrix(i+1,l)=MomentDistributionMatrix(i,l+1)/2;
           
         end
         
       elseif(LeftEndCorrection==1 && LeftSupport == 2) ,
       
         if (k ~= 1) , %%Maybe Not Generalised
           
           MomentDistributionMatrix(i+1,l)=MomentDistributionMatrix(i,l+1)/2;
           
         end
               
       else ,
        
         MomentDistributionMatrix(i+1,l)=MomentDistributionMatrix(i,l+1)/2;
       
       end ; 
       
       %disp("Distributing")
       MomentDistributionMatrix(i,l+2)=DistributionFactorMatrix(l+1,1)*ExternalMoment;
       
       %disp("Carry Over To Right :")
       if(RightEndCorrection==1 && InputMatrix(temp(1),2)~=2) ,
 
         if ((k~=((temp(1)-2)*2)) && ((temp(1)>2))) ,
             
           MomentDistributionMatrix(i+1,l+3)=MomentDistributionMatrix(i,l+2)/2;
           
         elseif ((k~=((temp(1)-2)*2)) && ((temp(1)<=2))) ,
           
           MomentDistributionMatrix(i+1,l+3)=MomentDistributionMatrix(i,l+2)/2;
           
         end
         
       elseif(RightEndCorrection==1 && InputMatrix(temp(1),2)==2) ,
       
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
     
     MomentDistributionMatrix=(round(MomentDistributionMatrix.*100))/100;
     
     end
     
   end
   
