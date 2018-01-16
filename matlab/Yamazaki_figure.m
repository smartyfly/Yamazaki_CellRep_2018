% This script generates figure 4 using the data 'SummaryData_man.mat',
% which contains all the calcium imaging data (extracted) plus some represetative
% images. Please excute this with putting the mat file in the same
% directory.

clear
load SummaryData_man.mat % data set for Ca imaging 

TPF = 0.14932; % time (sec) per frame
xyresol = 0.5680; % microm per pixel
NoF = 340; % # of frames to analyze
Time = (TPF:TPF:TPF*NoF)';
DisplayTime = [10 45]; % time range to display
StimTime = [15 35]; % timing of stimlation

ColorP = [hex2dec('00')/256 hex2dec('95')/256 hex2dec('FF')/256];
ColorN = [hex2dec('FF')/256 hex2dec('92')/256 hex2dec('00')/256];

f1 = figure('Color',[1 1 1 0],'Position',[0 0 1000 850],'Renderer','painters');

%% CreN Low15%
AllData = [CreNChrmTomLow15; CreNTomLow15];
minY = min(AllData(:))*.7;
maxY = max(AllData(:))*.7;

subplot(4,3,10) % low15 for CreN > Chrm::Tom, CreN > Tom
shadedErrorBar(Time,nanmean(CreNTomLow15,1),nanstd(CreNTomLow15)./sqrt(size(CreNTomLow15,1)),{'Color',[.5 .5 .5],'LineWidth',3},0.8);
hold on;
shadedErrorBar(Time,nanmean(CreNChrmTomLow15,1),nanstd(CreNChrmTomLow15)./sqrt(size(CreNChrmTomLow15,1)),{'Color',ColorP,'LineWidth',3},0.7);
line([Time(1) Time(end)],[0 0],'LineStyle',':','Color',[.1 .1 .1],'LineWidth',1);
line(StimTime,[minY minY],'LineStyle','-','Color',[1 0 0 .4],'LineWidth',10);
line([10 10],[.04 .14],'Color',[0 0 0],'LineWidth',6); % y axis scale 0.1
xlim(DisplayTime); % ylim([minY maxY]);
hold off;
box off;axis off;
text([1.2 1.2],[.96 .84],...
    {['\color[rgb]{' regexprep(mat2str(ColorP),']|[','') '}\gammaCRE-n>CsChrimson::tdTomato "\gammaCRE-p"'];...
    ['\color[rgb]{.2 .2 .2}\gammaCRE-n>tdTomato "\gammaCRE-p"']},...
    'HorizontalAlignment','right','Units','normalized');
text(-.05,1.05,'H',...
    'FontWeight','bold','FontSize',18,...
    'HorizontalAlignment','right','Units','normalized');

subplot(4,3,11) % difference Chrm::Tom & Tom
deltaLowN = nanmean(CreNChrmTomLow15,1) - nanmean(CreNTomLow15,1);
deltaTopN = nanmean(CreNChrmTomTop15,1) - nanmean(CreNTomTop15,1);
deltaLowNttx = nanmean(CreNChrmTomTtxLow15,1) - nanmean(CreNTomTtxLow15,1);
deltaTopNttx = nanmean(CreNChrmTomTtxTop15,1) - nanmean(CreNTomTtxTop15,1);
plot(Time,deltaLowNttx,'Color',[.6 .6 .6],'LineWidth',3);
hold on;
plot(Time,deltaLowN,'Color',ColorP,'LineWidth',3);
line([Time(1) Time(end)],[0 0],'LineStyle',':','Color',[.1 .1 .1],'LineWidth',1);
line(StimTime,[minY minY]*.7,'LineStyle','-','Color',[1 0 0 .4],'LineWidth',10);
line([10 10],[.02 .07],'Color',[0 0 0],'LineWidth',6); % y axis scale 0.05
xlim(DisplayTime); % ylim([minY maxY]);
hold off;
box off;axis off;
text(.97,.45,'\color[rgb]{.6 .6 .6}+ TTX','HorizontalAlignment','right','Units','normalized');
text(1,1.05,...
    ['\color[rgb]{' regexprep(mat2str(ColorP),']|[','') '} "\gammaCRE-p"'],...
    'HorizontalAlignment','right','Units','normalized');
text(-.05,1.05,'J',...
    'FontWeight','bold','FontSize',18,...
    'HorizontalAlignment','right','Units','normalized');

%% CreP Low15%
AllData = [CrePChrmTomLow15; CrePTomLow15];
minY = min(AllData(:))*.7;
maxY = max(AllData(:))*.7;

subplot(4,3,7) % low15 for CreP > Chrm::Tom, CreP > Tom
shadedErrorBar(Time,nanmean(CrePTomLow15,1),nanstd(CrePTomLow15)./sqrt(size(CrePTomLow15,1)),{'Color',[.5 .5 .5],'LineWidth',3},0.7);
hold on;
shadedErrorBar(Time,nanmean(CrePChrmTomLow15,1),nanstd(CrePChrmTomLow15)./sqrt(size(CrePChrmTomLow15,1)),{'Color',ColorN,'LineWidth',3},0.7);
line([Time(1) Time(end)],[0 0],'LineStyle',':','Color',[.1 .1 .1],'LineWidth',1);
line(StimTime,[minY minY],'LineStyle','-','Color',[1 0 0 .4],'LineWidth',10);
line([10 10],[.04 .14],'Color',[0 0 0],'LineWidth',6); % y axis scale 0.1
xlim(DisplayTime);% ylim([minY maxY]);
hold off;
box off;axis off;
text([1.2 1.2],[.9 .78],...
    {['\color[rgb]{' regexprep(mat2str(ColorN),']|[','') '}\gammaCRE-p>CsChrimson::tdTomato "\gammaCRE-n"'];...
    ['\color[rgb]{.2 .2 .2}\gammaCRE-p>tdTomato "\gammaCRE-n"']},...
    'HorizontalAlignment','right','Units','normalized');
text(-.05,1.05,'G',...
    'FontWeight','bold','FontSize',18,...
    'HorizontalAlignment','right','Units','normalized');

subplot(4,3,8) % difference Chrm::Tom & Tom
deltaLowP = nanmean(CrePChrmTomLow15,1) - nanmean(CrePTomLow15,1);
deltaTopP = nanmean(CrePChrmTomTop15,1) - nanmean(CrePTomTop15,1);
deltaLowPttx = nanmean(CrePChrmTomTtxLow15,1) - nanmean(CrePTomTtxLow15,1);
deltaTopPttx = nanmean(CrePChrmTomTtxTop15,1) - nanmean(CrePTomTtxTop15,1);
plot(Time,deltaLowPttx,'Color',[.6 .6 .6],'LineWidth',3);
hold on;
plot(Time,deltaLowP,'Color',ColorN,'LineWidth',3);
line([Time(1) Time(end)],[0 0],'LineStyle',':','Color',[.1 .1 .1],'LineWidth',1);
line(StimTime,[minY minY],'LineStyle','-','Color',[1 0 0 .4],'LineWidth',10);
line([10 10],[.02 .07],'Color',[0 0 0],'LineWidth',6); % y axis scale 0.05
xlim(DisplayTime); % ylim([minY maxY]);
hold off;
box off;axis off;
text(.97,.3,'\color[rgb]{.6 .6 .6}+ TTX','HorizontalAlignment','right','Units','normalized');
text(1,.7,...
    {['\color[rgb]{' regexprep(mat2str(ColorN),']|[','') '}"\gammaCRE-n"']},...
    'HorizontalAlignment','right','Units','normalized');
text(-.05,1.05,'I',...
    'FontWeight','bold','FontSize',18,...
    'HorizontalAlignment','right','Units','normalized');

%% CreP & CreN Red images
Im1 = subplot(4,3,1); % CreP
[sizew, sizeh] = size(RedCreP);
imagesc([0 sizeh*xyresol],[0 sizew*xyresol],RedCreP);axis image; axis off;
colormap(Im1,'gray');
text(-.05,1.05,'A',...
    'FontWeight','bold','FontSize',18,...
    'HorizontalAlignment','right','Units','normalized');
text(.02,.05,'\color[rgb]{1 1 1}\gammaCRE-p>CsChrimson::tdTomato',...
    'FontSize',10,'HorizontalAlignment','left','Units','normalized');
% a scale bar (10 micron) for image A 
hold on;
quiver(30,4,10/xyresol,0,'ShowArrowHead','off','LineWidth',6,'Color','w');
hold off;
Ptop15 = prctile(RedCreP(RedCreP(:)>0),85);
Plow15 = prctile(RedCreP(RedCreP(:)>0),15);
P_roi = imfuse(RedCreP<Plow15&RedCreP>0,RedCreP>Ptop15,'falsecolor');
subplot 433
imagesc(P_roi);axis image;axis off;
text(.04,.04,{'\color[rgb]{1 0 1}top15%';'\color[rgb]{0 1 0}bottom15%'},...
    'FontSize',10,'VerticalAlignment','bottom','HorizontalAlignment',...
    'left','Units','normalized');
text(-.05,1.05,'E',...
    'FontWeight','bold','FontSize',18,...
    'HorizontalAlignment','right','Units','normalized');
axis off;

Im2 = subplot(4,3,4); % CreN
imagesc(RedCreN);axis image; axis off;
colormap(Im2,'gray');
text(-.05,1.05,'B',...
    'FontWeight','bold','FontSize',18,...
    'HorizontalAlignment','right','Units','normalized');
text(.02,.05,'\color[rgb]{1 1 1}\gammaCRE-n>CsChrimson::tdTomato',...
    'FontSize',10,'HorizontalAlignment','left','Units','normalized');
Ntop15 = prctile(RedCreN(RedCreN(:)>0),85);
Nlow15 = prctile(RedCreN(RedCreN(:)>0),15);
N_roi = imfuse(RedCreN<Nlow15&RedCreN>0,RedCreN>Ntop15,'falsecolor');
subplot 436
imagesc(N_roi);axis image;axis off;
text(.04,.04,{'\color[rgb]{1 0 1}top15%';'\color[rgb]{0 1 0}bottom15%'},...
    'FontSize',10,'VerticalAlignment','bottom','HorizontalAlignment',...
    'left','Units','normalized');
text(-.05,1.05,'F',...
    'FontWeight','bold','FontSize',18,...
    'HorizontalAlignment','right','Units','normalized');
axis off;

%% CreN ttx percentile plot
subplot 432
line([16.5 16.5],[-1 1],'LineStyle','-','Color',[.8 .8 .8],'LineWidth',4);hold on;
Order = 10:-1:1;
for ii=10:-1:1
    h(Order(ii)) = plot(Time,PrctileCreNChrmTtxAve(ii,:),'Color',[1 0 0 ii/10],'LineWidth',3);
end
xlim(DisplayTime);ylim([-.1 1])
line(DisplayTime,[0 0],'LineStyle',':','Color',[.1 .1 .1]);
YLIM = get(gca,'YLim');
line(StimTime,[YLIM(1) YLIM(1)],'LineStyle','-','Color',[1 0 0 .4],'LineWidth',10);
ylabel('normalized \deltaF/F0');yticks(0:.2:.8);
legend(h,{'~100%';'~90%';'~80%';'~70%';'~60%';'~50%';'~40%';'~30%';'~20%';'~10%'},...
    'FontSize',8,'Position',[0.59 0.81 0.05 0.1]);
legend boxoff;
text(.5,1,'\color[rgb]{0 0 0}+TTX',...
    'FontWeight','bold','FontSize',12,...
    'HorizontalAlignment','center','Units','normalized');
text(-.05,1.05,'C',...
    'FontWeight','bold','FontSize',18,...
    'HorizontalAlignment','right','Units','normalized');

%% CreN CreP ttx percentile vs deltaF plot
subplot 435
plot(5:10:95,PrctileCreNChrmTtxAve(:,110)','k-o','LineWidth',2,...
    'MarkerSize',8);hold on;
plot(5:10:95,PrctileCrePChrmTtxAve(:,110)','k-x','LineWidth',2,...
    'MarkerSize',8);
patch([85 100 100 85],[-1 -1 1 1],'k','LineStyle','none');
alpha .3;
patch([0 15 15 0],[-1 -1 1 1],'k','LineStyle','none');
alpha .3
xlim([0 100]);ylim([-.1 1]);
% title('dose response curves by tdTomato intensities');
ylabel('normalized \deltaF/F0');yticks(0:.2:.8);
xlabel('fraction of tdTomato intensity')
box off;
legend({'\gammaCRE-n>CsChrimson::tdTomato';'\gammaCRE-p>CsChrimson::tdTomato'},...
    'FontSize',9,'Position',[0.49 0.685 0.02 0.015]);
legend boxoff;
text(-.05,1.05,'D',...
    'FontWeight','bold','FontSize',18,...
    'HorizontalAlignment','right','Units','normalized');

%% set all the font to Helvetica
fighandles = findall( allchild(0), 'type', 'figure');
set(fighandles(1).Children, 'FontName', 'Helvetica');
set(findall(gcf,'Type','text'), 'FontName', 'Helvetica');
%% Save pdf
f1.PaperOrientation = 'portrait';
f1.PaperType = 'a3';
export_fig([pwd '/Figure4.pdf'], '-pdf', '-painters', '-cmyk', f1);
% use the following code in case to print the figure without 'export_fig' command
% print(f1,[pwd '/Figure.pdf'],'-painters','-dpdf','-cmyk','-bestfit');