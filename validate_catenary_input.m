function valid = validate_catenary_input(D, L, M)
% Preveri veljavnost vhodnih parametrov veriznice.
%
% D = razdalja med obesisci
% L = vrstica dolzin (leve) polovice palic
% M = vrstica mas (leve) polovice palic
%
% Izhodne spremenljivke:
% valid = 0, ce nismo zaznali napak, sicer > 0

    valid = 0;

    valid += D > 2 * sum(L);  % imamo dovolj dolge clenke, da razpnemo veriznico
    valid += D <= 0;  % razdalja med obesisci je pozitivna
    valid += sum(L <= 0);  % dolzine clenkov so pozitivne
    valid += sum(M <= 0);  % mase clenkov so pozitivne
end
