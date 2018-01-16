# Matlab m script list (in the order of processing):
### CompareRedCh_GreenCh_gradientPlo.m
extracts average dF/F0 for each red fraction and saves the value as xls and figures as pdf.

### Yamazaki_figure.m
generates Figure4.pdf from the matlab file "SummaryData_man.mat".

### SummaryData_man.mat
Data file that contains dF/F0 values of the experimental and contorol samples. There are also representative images in the mat file.

##### dependency:
- **Matlab**
- **Image Processing Toolbox**
- **Statistics and Machine Learning Toolbox**
- [xlscol.m](https://jp.mathworks.com/matlabcentral/fileexchange/28343-column-converter-for-excel)
- [xlwrite.m](https://jp.mathworks.com/matlabcentral/fileexchange/38591-xlwrite--generate-xls-x--files-without-excel-on-mac-linux-win)
- [bfmatlab](https://docs.openmicroscopy.org/bio-formats/5.7.2/users/matlab/index.html)
- [TIFFStack](https://jp.mathworks.com/matlabcentral/fileexchange/32025-dylanmuir-tiffstack)
- [export-fig](https://jp.mathworks.com/matlabcentral/fileexchange/23629-export-fig)
- [shadedErrorBar.m](https://jp.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar)
