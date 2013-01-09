function [p,J,dJ] = contactPositions(obj,q)
% @retval p(:,i)=[px;pz] is the position of the ith contact point 
% @retval J is dpdq
% @retval dJ is ddpdqdq

kinsol = doKinematics(obj,q,nargout>2);

contact_pos = zeros(2,obj.num_contacts)*q(1);  % *q(1) to help TaylorVar
if (nargout>1) 
  J = zeros(2*obj.num_contacts,obj.num_q)*q(1); 
end
count=0;

nBodies = obj.featherstone.NB + 1;
for i=1:nBodies
  contact_pts = obj.body(i).contact_pts;
  nC = size(contact_pts,2);
  if nC>0
    if (nargout>2)
      [contact_pos(:,count+(1:nC)),J(2*count+(1:2*nC),:),dJ(2*count+(1:2*nC),:)] = forwardKin(obj,kinsol,i,contact_pts);
    elseif (nargout>1)
      [contact_pos(:,count+(1:nC)),J(2*count+(1:2*nC),:)] = forwardKin(obj,kinsol,i,contact_pts);
    else
      [contact_pos(:,count+(1:nC))] = forwardKin(obj,kinsol,i,contact_pts);
    end
    count = count + nC;
  end
end
p = contact_pos;
end
