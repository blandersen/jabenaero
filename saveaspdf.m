function fname = saveaspdf(fname)
% Save current figure as pdf
cd figures
exportgraphics(gcf, fname, 'ContentType', 'vector');
cd ..
end

