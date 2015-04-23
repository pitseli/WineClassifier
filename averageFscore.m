function [ average ] = averageFscore( scores )
%averageFscore provides a weighted average F score for the challenge
%dataset from the ML project.
%
%   Requires:
%   - scores: column vector of length 2 (only type), 7 (only quality)
%     or 9 (both)
%   Returns:
%   - av: the weighted average

challengeset = [0 0;25 1;142 39;343 65;259 85;31 5;4 1;];

if length(scores) == 2
    % Expect types
    x = sum(challengeset)';
    average = sum(x .* scores)/sum(x);
elseif length(scores) == 7
    % Expect quality
    x = sum(challengeset,2);
    average = sum(x .* scores)/sum(x);
elseif length(scores) == 9
    % Expect both
    x = [sum(challengeset)'; sum(challengeset,2)];
    average = sum(x .* scores)/sum(x);
else
    disp('Sorry, please provide a vector of length 2, 7 or 9');
end

end

