%%
clear
Process=[21:22];
% selecting a folder to open csv files
if exist('Path','var')==1
    Initial = Path;
else
    Initial = '~/Desktop/';
end

Path = uigetdir(Initial);

DB = datastore(Path,'IncludeSubfolders',true,'FileExtensions','.tif','Type','image');
[~,FileName,~] = cellfun(@fileparts, DB.Files, 'UniformOutput',false);
DB.Files = DB.Files(~startsWith(FileName,'._')); % remove hidden file entries starts with '._'
NumImages = length(DB.Files);

%% create the result folder and save txt
% create NoRMCorre directory to save files
t = datestr(now,'mmm-dd-yyyy_HH:MM:SS'); % get current time
if exist([Path '/RGanalysis'],'dir')~=7
    mkdir([Path '/RGanalysis/']);
end
mkdir([Path '/RGanalysis/' strrep(t,':','-')]);

ResultFilename = [Path '/RGanalysis/' strrep(t,':','-') '/results_' strrep(t,':','-') '.txt'];
ResultFid = fopen(ResultFilename, 'w' );
fprintf(ResultFid, 'Loaded images: (%s)\n', t);
for ii = 1:NumImages
    File = strsplit(DB.Files{ii},'/');
    fprintf(ResultFid, '%d: %s\n', ii, File{end});
end
fprintf(ResultFid, '[EOL]\n\n');
fclose(ResultFid);
tempFilenameTop = [Path '/RGanalysis/' strrep(t,':','-') '/tempT.txt'];
tempFilenameLow = [Path '/RGanalysis/' strrep(t,':','-') '/tempL.txt'];

%% Select channels
% loading reference red stack
nref = 1;
[Hr, Wr, NoFr, Zr, CHr, dimOrderr, colorBitr, metaImJr] = getbfImageInfo(DB.Files{nref});
StackRRef = bfopen(DB.Files{nref});
YRef = permute(reshape(cell2mat(StackRRef{1,1}(:,1)),[Hr CHr Zr NoFr Wr]),[1 5 2 3 4]);
RedRef = mean(YRef(:,:,1,1,:),5);

for n = Process
    % loading target green
    % n = 21;
    StimStart = 15;
    StimEnd = 36;
    % [FilePath,File,Ext] = fileparts(DB.Files{n});
    % if startsWith(File,'.') % ignore hidden files (MacOS)
    %     continue
    % end
    [H, W, NoF, Z, CH, dimOrder, colorBit, metaImJ] = getbfImageInfo(DB.Files{n});
    %     TPF = double(metaImJ.value{'Frame Interval'}.value()); % get frame interval value
    TPF = double(metaImJ.value{'Frame Interval'});
    Time = (TPF:TPF:TPF*NoF)';
    % loading target stack
    Stack = bfopen(DB.Files{n});
    Y = permute(reshape(cell2mat(Stack{1,1}(:,1)),[H CH Z NoF W]),[1 5 2 3 4]);
    
    fPlay = figure;
    subplot 322
    imagesc(RedRef);axis image % averaged Red image
    title('Red Ch')
    maxX = max(RedRef(:));
    maxY = max(Y(:));
    minX = min(RedRef(:));
    minY = min(Y(:));
    Red = RedRef;
    %     uniRed = unique(round(Red));
    %     Counts = histcounts(round(Red(:)),0:max(round(Red(:))));
    %     Counts(Counts==0) = [];
    %     NoOccur = zeros(size(RedRef(:)));
    %     Lookup = [uniRed Counts'];
    %     for ii=1:length(uniRed)
    %         NoOccur(round(Red(:))==uniRed(ii)) = Lookup(ii,2);
    %     end
    Class = 0:10:100;
    RedPrctile = prctile(Red(Red(:)>0),Class);
    RedClassIdx = repmat(logical(Red),[1 1 10]);
    for ii=1:length(Class)-1
        RedClassIdx(:,:,ii) = Red<RedPrctile(ii+1) & Red>=RedPrctile(ii);
    end
    top10 = prctile(Red(Red(:)>0),85);
    low10 = prctile(Red(Red(:)>0),15);
    top10idx = Red>top10;
    low10idx = Red<low10&Red>0;
    middleidx = Red<=top10&Red>=low10;
    StimON = Time>StimStart&Time<StimEnd;
    %     for ii=1:NoF
    %         % R/G plot
    %         subplot 121
    %         Red = RedRef;
    %         Rt10 = RedRef(top10idx);
    %         % Red(RedRef==0) = [];
    %         % Red = YRef(:,:,1,1,ii);
    %         Green = Y(:,:,1,1,ii);
    %         Gt10 = Green(top10idx);
    %         % Green(RedRef==0) = [];
    %         % [n,c] = hist3([Red(:), Green(:)]);
    %         if StimON(ii)
    %             % contour(c{1},c{2},n);hold on;
    %             scatter(Red(:),Green(:),20,'.r','MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
    %             % scatter(Rt10(:),Gt10(:),40,'.r','MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);hold off;
    %         else
    %             % contour(c{1},c{2},n);hold on;
    %             scatter(Red(:),Green(:),20,'.b','MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1)
    %         end
    %         line([top10 top10],[minY maxY],'Color',[1 0 1])
    %         line([low10 low10],[minY maxY],'Color',[1 0 1])
    %         title(['frame = ' num2str(ii)])
    %         xlim([minX maxX]);ylim([minY maxY])
    %         % Green plot
    %         subplot 324
    %         imagesc(Y(:,:,1,1,ii));axis image;caxis([minY maxY*.8]);
    %         title('Green Ch')
    %         pause(.001)
    %     end
    Gseq = reshape(Y,[H*W NoF CH Z]);
    hFig = figure('Position',[0 0 800 300],'Renderer','painters');
    subplot 121
    imagesc(Red);axis image;
    colormap gray;
    box off;axis off;
    subplot 122
    PrctileAve = zeros(10,length(Time));
    for ii=1:10
        PrctileAve(ii,:) = nanmean(Gseq(RedClassIdx(:,:,ii),:),1);
        plot(Time,PrctileAve(ii,:),'Color',[1 0 0 ii/10],'LineWidth',2);hold on;
        xlim([10 45]);ylim([-.1 1])
    end
    line([minX maxX],[0 0],'LineStyle',':','Color',[.1 .1 .1])
    legend({'<10%';'20%';'30%';'40%';'50%';'60%';'70%';'80%';'<90%'});
    title('Average traces by tdTomato Intensity');
    [Pathstr,Name,~] = fileparts(ResultFilename);
    ResultFid2 = fopen([Pathstr '/percentile.txt'], 'a');
    fprintf(ResultFid2, '\n\nimage:\t(%s)\n', FileName{n});
    fclose(ResultFid2);
    dlmwrite([Pathstr '/percentile.txt'],PrctileAve,'delimiter','\t','-append');
    xlwrite([Pathstr '/percentile.xlsx'],{Name},num2str(n),'A1');
    xlwrite([Pathstr '/percentile.xlsx'],PrctileAve,num2str(n),'A2');
    print(hFig,[fileparts(ResultFilename) '/' FileName{n} '.pdf'],'-dpdf','-cmyk');
    
    figure(fPlay);
    subplot 324
    shadedErrorBar(Time,nanmean(Gseq(top10idx(:),:),1),nanstd(Gseq(top10idx(:),:)),'r');hold on;
    line([minX maxX],[0 0],'LineStyle',':','Color',[.1 .1 .1])
    xlim([Time(1) Time(end)]);ylim([minY maxY])
    subplot 326
    shadedErrorBar(Time,nanmean(Gseq(low10idx(:),:),1),nanstd(Gseq(low10idx(:),:)),'b');hold on;
    line([minX maxX],[0 0],'LineStyle',':','Color',[.1 .1 .1])
    xlim([Time(1) Time(end)]);ylim([minY maxY])
    subplot 323
    plot(Time,Gseq(top10idx(:),:),'-','Color',[1 0 0 .5])
    line([minX maxX],[0 0],'LineStyle',':','Color',[.1 .1 .1])
    xlim([Time(1) Time(end)]);ylim([minY maxY])
    subplot 325
    plot(Time,Gseq(low10idx(:),:),'-','Color',[0 0 1 .5])
    line([minX maxX],[0 0],'LineStyle',':','Color',[.1 .1 .1])
    xlim([Time(1) Time(end)]);ylim([minY maxY])
    
    subplot 321
    P_roi = imfuse(Red<low10&Red>0,Red>top10,'falsecolor');
    imagesc(P_roi);
    text(.95,.05,{'\color[rgb]{1 0 1}upper15%';'\color[rgb]{0 1 0}lower15%'},...
        'VerticalAlignment','bottom','HorizontalAlignment','right','Units','normalized');
    axis off;axis image;
    
    ResultFid = fopen(ResultFilename, 'a');
    fprintf(ResultFid, '\n\nimage:\t(%s)\n', FileName{n});
    fprintf(ResultFid, 'top10:\t%f\n', top10);
    fprintf(ResultFid, 'low10:\t%f\n', low10);
    fclose(ResultFid);
    dlmwrite(ResultFilename,[nanmean(Gseq(top10idx(:),:),1);nanmean(Gseq(low10idx(:),:),1)],'delimiter','\t','-append');
    dlmwrite(tempFilenameTop,nanmean(Gseq(top10idx(:),:),1),'delimiter','\t','-append');
    dlmwrite(tempFilenameLow,nanmean(Gseq(low10idx(:),:),1),'delimiter','\t','-append');
    
    print(fPlay,[Path '/RGanalysis/' FileName{n} '.pdf'],'-dpdf','-cmyk');
    % close(fPlay)
    %
    %     figure
    %     h1 = subplot(2,3,1);
    %     title('pre')
    %     hold on
    %     h2 = subplot(2,3,2);
    %     title('stim-on')
    %     hold on
    %     h3 = subplot(2,3,3);
    %     title('post')
    %     hold on
    %     for ii=1:NoF
    %         Red = RedRef;
    %         % Red = YRef(:,:,1,1,ii);
    %         Green = Y(:,:,1,1,ii);
    %         StimON = Time>StimStart&Time<=StimEnd;
    %         StimOFF = Time>StimEnd;
    %         if StimON(ii)
    %             subplot 232
    %             scatter(Red(:),Green(:),10,'.r','MarkerFaceAlpha',.01,'MarkerEdgeAlpha',.01);
    %             xlim([minX maxX]);ylim([minY maxY])
    %         elseif StimOFF(ii)
    %             subplot 233
    %             scatter(Red(:),Green(:),10,'.b','MarkerFaceAlpha',.01,'MarkerEdgeAlpha',.01);
    %             xlim([minX maxX]);ylim([minY maxY])
    %         else
    %             subplot 231
    %             scatter(Red(:),Green(:),10,'.g','MarkerFaceAlpha',.01,'MarkerEdgeAlpha',.01);
    %             xlim([minX maxX]);ylim([minY maxY])
    %         end
    %     end
    %
    %     h = subplot(2,3,4);
    %     copyobj([get(h2,'Children'); get(h3,'Children'); get(h1,'Children')],h)
    %     line([top10 top10],[minY maxY],'Color',[1 0 1])
    %     line([low10 low10],[minY maxY],'Color',[1 0 1])
    %     xlim([minX maxX]);ylim([minY maxY])
    %     title(FileName{n})
    %     subplot 235
    %     hs = histogram(RedRef(:));
    %     title('histogram (Red)')
    %     xlabel('Red intensity')
    %     % set(gca,'YScale','log')
    %     subplot 236
    %     Im = imagesc(RedRef);
    %     axis image
end

AllTop = dlmread(tempFilenameTop,'\t');
AllLow = dlmread(tempFilenameLow,'\t');

ResultFid = fopen(ResultFilename, 'a');
fprintf(ResultFid, '\n\nAverage:\t\n');
fclose(ResultFid);
dlmwrite(ResultFilename,[nanmean(AllTop,1);nanmean(AllLow,1)],'delimiter','\t','-append');
delete(tempFilenameTop);
delete(tempFilenameLow);

for n = 1:length(Process)
    Class10(:,:,n) = xlsread([Pathstr '/percentile.xlsx'],num2str(Process(n)),['A2:' xlscol(400) '15']);
end
xlwrite([Pathstr '/percentile.xlsx'],nanmean(Class10,3),'Average','A1');

% tilefigs
close all