function [g]=gerarand(n)
	for i = 1:n
		osvaldo = rand();
		if (osvaldo > .5)
			g(i) = 1;
		else
			g(i) = 0;
		end
	end
end
