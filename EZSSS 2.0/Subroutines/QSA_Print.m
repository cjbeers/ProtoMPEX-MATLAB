function QSA_Print(ii,NDT)

if (ii==1)
    fprintf('\n            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
    fprintf('            ~~~~~~    Quasistatic Calculation: %3i of %3i    ~~~~~~\n',ii,NDT)
else
    fprintf('            ~~~~~~                             %3i of %3i    ~~~~~~\n',ii,NDT)
end
if (ii==NDT)
    fprintf('            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
end

end