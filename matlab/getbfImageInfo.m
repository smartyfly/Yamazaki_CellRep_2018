function [H, W, NoF, Z, CH, dimOrder, colorBit, metaImJ] = getbfImageInfo(filepath)

[Path, File, Ext] = fileparts(filepath);

%% bfGetReader metaData
r = bfGetReader([Path '/' File Ext]);
colorBit = r.getBitsPerPixel();
dimOrder = r.getDimensionOrder();
CH = r.getSizeC();
NoF = r.getSizeT();
W = r.getSizeX();
H = r.getSizeY();
Z = r.getSizeZ();

%% oroginal and global meta data
omeMeta = r.getMetadataStore(); % OME metadata
oriMeta = r.getGlobalMetadata(); % Original metadata

% all the item in the metadata
metadataKeys = oriMeta.keySet().iterator();
metaImJ = cell(oriMeta.size(),2);
for i=1:oriMeta.size()
  key = metadataKeys.nextElement();
  value = oriMeta.get(key);
  metaImJ(i,:) = {key, value};
end
metaImJ(cellfun(@(s) strcmp(s,char(160)), metaImJ(:,1)),:) = []; % delete empty RowNames
metaImJ = table(metaImJ(:,2),'VariableNames',{'value'},'RowNames',metaImJ(:,1));
metaImJ = sortrows(metaImJ,'RowNames');
clear key value i