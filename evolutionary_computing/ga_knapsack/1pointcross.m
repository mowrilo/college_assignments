function [offs] = 1pointcross(parents,nobj)

	npos = randi(nobj);
	rubens = parents(1,1:npos);
	parents(1,1:npos) = parents(2,1:npos);
	parents(2,1:npos) = rubens;
	offs = parents;	

end
