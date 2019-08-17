## Author: Nikhil Dandamudi
## Created: 2019-08-09

function MomentDistributionMatrix = MomentDistribution (InputMatrix, FixedEndMomentMatrix, DistributionFactorMatrix)
  
  j=1;
  
%%Inputing Values of Exiting Moment Into Matrix :
  
  for i=1:((size(InputMatrix)(1))*2)                           
    if(rem(i,2)~= 0) ,

      MomentDistributionMatrix(1,i)=FixedEndMomentMatrix(j,1);

    else ,

      MomentDistributionMatrix(1,i)=FixedEndMomentMatrix(j,2);
      j=j+1;
      
    endif
    
  end
  
  EndCorrection=[0];
  %%MomentDistributionMatrix
  
%% END CORRECTION (IF ANY) :
  
  if ((InputMatrix(size(InputMatrix)(1),2)==0) && (MomentDistributionMatrix (MomentDistributionMatrix(1,size(MomentDistributionMatrix)(2))~=0))) ,

    Correction=0;
    Correction=MomentDistributionMatrix(1,size(MomentDistributionMatrix)(2))*-1;
    MomentDistributionMatrix(1,size(MomentDistributionMatrix)(2))=MomentDistributionMatrix(1,size(MomentDistributionMatrix)(2)) + Correction;
    MomentDistributionMatrix(1,(size(MomentDistributionMatrix)(2)-1))=(MomentDistributionMatrix(1,size(MomentDistributionMatrix)(2)-1) + (Correction/2));
    EndCorrection=[1];
    
  endif
  
  if (InputMatrix(size(InputMatrix)(1),2)==2) , %%Overhanging Continuous Beam
    
    Correction=0;
    Correction=(MomentDistributionMatrix(1,size(MomentDistributionMatrix)(2)-2)+MomentDistributionMatrix(1,size(MomentDistributionMatrix)(2)-1))*-1;
    MomentDistributionMatrix(1,size(MomentDistributionMatrix)(2)-2)=MomentDistributionMatrix(1,size(MomentDistributionMatrix)(2)-2) + Correction;
    MomentDistributionMatrix(1,(size(MomentDistributionMatrix)(2)-3))=(MomentDistributionMatrix(1,size(MomentDistributionMatrix)(2)-3) + (Correction/2));
    EndCorrection=[1];
    
  endif
  
  %%MomentDistributionMatrix
    
%% ITERATIVE PROCESS OF DISTRIBUTION THEORM:

   i=2;
   j=3;
   l=1;
           %sum(abs(MomentDistributionMatrix'))(i-1) > (0.01)*(size(InputMatrix)(1))
   while (sum(abs(MomentDistributionMatrix'))(i-1) > (0.01)*(size(InputMatrix)(1))) ,
     
     l=1;
     
     for k=1:(size((InputMatrix)(1)-1)*2) , %% Inputs elements into respective columns for a row
       
       ExternalMoment=(MomentDistributionMatrix(i-1,l+1)+MomentDistributionMatrix(i-1,l+2))*-1;
       %disp("Distributing")
       MomentDistributionMatrix(i,l+1)= DistributionFactorMatrix(l,1)*ExternalMoment;
       %disp("Carry Over To Left :")
       MomentDistributionMatrix(i+1,l)=MomentDistributionMatrix(i,l+1)/2; 
       %disp("Distributing")
       MomentDistributionMatrix(i,l+2)=DistributionFactorMatrix(l+1,1)*ExternalMoment;
       %disp("Carry Over To Right :")
       if(EndCorrection==1 && InputMatrix(size(InputMatrix)(1),2)~=2) ,
           
         if ((k~=((size((InputMatrix)(1)-1)*2))) && (size(InputMatrix)>2)) ,
            
           MomentDistributionMatrix(i+1,l+3)=MomentDistributionMatrix(i,l+2)/2;
           
         elseif ((k~=((size((InputMatrix)(1)-1)*2)-1)) && (size(InputMatrix)<=2)) ,
           
           MomentDistributionMatrix(i+1,l+3)=MomentDistributionMatrix(i,l+2)/2;
           
 
         endif
         
       elseif(EndCorrection==1 && InputMatrix(size(InputMatrix)(1),2)==2) ,
       
         if (k~=((size((InputMatrix)(1)-2)*2)-1)) , %%Maybe Not Generalised
           
           MomentDistributionMatrix(i+1,l+3)=MomentDistributionMatrix(i,l+2)/2;
           
         endif    
         
       
       else ,
       
         MomentDistributionMatrix(i+1,l+3)=MomentDistributionMatrix(i,l+2)/2;
       
     endif 
     
       if (InputMatrix(size(InputMatrix)(1),2)==2 && size(InputMatrix)(1)<=3 ),
         
           break;
 
       endif
       
       if (size(InputMatrix)(1)<= 2),
         
         break;
         
       endif
          
       l=l+2;
       
     end 
     
     if (InputMatrix(size(InputMatrix)(1),2)==2 && size(InputMatrix)(1)<=3 ),
         
           break;
 
     endif
     
     if(size(InputMatrix)(1)<=2),
     
       break;
       
     endif
       
     i=i+2;
     
     %MomentDistributionMatrix=(round(MomentDistributionMatrix.*100))/100;
     
   end
endfunction
