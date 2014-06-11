% fetch and plot daily close for IBM

% when fetching, delete the sym column,
% and convert size to double:
ibm = fetch(h, ...
  ['update size:"f"$size from ', ...
	 'delete sym,price from select ', ...
	 'from daily where sym=`IBM'])

% convert result to matrix:
data = cell2mat(struct2cell(ibm)')

% generate tsobj for prices:
dates = data(:,1)
cols = {'open' 'high' 'low' 'close'}
fin = fints(dates, data(:,[2 3 4 5]),cols)

% priceandvol(data)
% plot(fin)

