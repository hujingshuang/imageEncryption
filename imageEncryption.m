function varargout = imageEncryption(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageEncryption_OpeningFcn, ...
                   'gui_OutputFcn',  @imageEncryption_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function imageEncryption_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.loadImage=0;            %载入图像状态
handles.encryption=0;           %加密状态
handles.imageSource=0;          %原始图像
handles.EncryptionImage=0;      %加密后
handles.EncryptionWay=0;        %加密方法
handles.unEncryptionImage=0;    %解密后的图像

guidata(hObject, handles);

function varargout = imageEncryption_OutputFcn(hObject, eventdata, handles) 
%隐藏图像框
set(handles.imageSrc,'Visible','off');
set(handles.imageDst,'Visible','off');
set(handles.imageUnEncryption,'Visible','off');

set(handles.imageSrc_hist,'Visible','off');
set(handles.imageDst_hist,'Visible','off');
set(handles.imageUnEncryption_hist,'Visible','off');

set(handles.beforeEncryptionCorr,'Visible','off');
set(handles.afterEncryptionCorr,'Visible','off');
set(handles.unEncryptionCorr,'Visible','off');

%隐藏标题文本
set(handles.imageSrc_text,'Visible','off');
set(handles.imageDst_text,'Visible','off');
set(handles.imageUnEncryption_text,'Visible','off');

set(handles.imageSrcHist_text,'Visible','off');
set(handles.imageDstHist_text,'Visible','off');
set(handles.imageUnEncryptionHist_text,'Visible','off');

set(handles.beforeEncryptionCorr_text,'Visible','off');
set(handles.afterEncryptionCorr_text,'Visible','off');
set(handles.unEncryptionCorr_text,'Visible','off');

varargout{1} = handles.output;

%--------------------------------------------------------------------
%位置置乱
function localEncryption_Callback(hObject, eventdata, handles)
if handles.loadImage==0                     %图像是否已载入
    warndlg('请选择图像！');
    return;
end
imgDst=imread(handles.imagePath);           %读取图像
if size(imgDst,3)==3
    imgDst=rgb2gray(imgDst);
end
based=str2num(get(handles.haltonBased,'string'));   %获取halton序列基数
if based<=1 || based>=1000 || based~=fix(based)
    warndlg('参数应为(1,1000)之间的整数！');
    return;
end
imgDst=locationExchange(imgDst,based);              %位置置乱(行置乱、列置乱)
axes(handles.imageDst);                             %显示原始图像
imshow(imgDst);
set(handles.imageDst_text,'Visible','on');

axes(handles.imageDst_hist);                        %显示原始图像直方图
imhist(imgDst);
set(handles.imageDstHist_text,'Visible','on');

handles.EncryptionImage=imgDst;                     %获取加密图像
handles.EncryptionWay=1;                            %加密方法
handles.encryption=1;                               %标记为已加密
msgbox('加密成功！','提示');

guidata(hObject, handles);
% --------------------------------------------------------------------
%像素置乱
function pixelEncryption_Callback(hObject, eventdata, handles)
if handles.loadImage==0
    warndlg('请选择图像！');
    return;
end
imgDst=imread(handles.imagePath);
if size(imgDst,3)==3
    imgDst=rgb2gray(imgDst);
end
based=str2num(get(handles.haltonBased,'string'));
if based<=1 || based>=1000 || based~=fix(based)
    warndlg('参数应为(1,1000)之间的整数！');
    return;
end
imgDst=pixelEncryption(imgDst,based);
axes(handles.imageDst);
imshow(imgDst);
set(handles.imageDst_text,'Visible','on');

axes(handles.imageDst_hist);
imhist(imgDst);
set(handles.imageDstHist_text,'Visible','on');
handles.EncryptionImage=imgDst;
handles.EncryptionWay=2;
handles.encryption=1;
msgbox('加密成功！','提示');

guidata(hObject, handles);
% --------------------------------------------------------------------
%先像素置乱，再位置置乱
function pixellocationEncryption_Callback(hObject, eventdata, handles)
if handles.loadImage==0
    warndlg('请选择图像！');
    return;
end

imgDst=imread(handles.imagePath);
if size(imgDst,3)==3
    imgDst=rgb2gray(imgDst);
end

based=str2num(get(handles.haltonBased,'string'));
if based<=1 || based>=1000 || based~=fix(based)
    warndlg('参数应为(1,1000)之间的整数！');
    return;
end

imgDst=pixelEncryption(imgDst,based);               %先像素置乱
imgDst=locationExchange(imgDst,based);              %再位置置乱
axes(handles.imageDst);
imshow(imgDst);
set(handles.imageDst_text,'Visible','on');

axes(handles.imageDst_hist);
imhist(imgDst);
set(handles.imageDstHist_text,'Visible','on');
handles.EncryptionImage=imgDst;
handles.EncryptionWay=3;
handles.encryption=1;
msgbox('加密成功！','提示');

guidata(hObject, handles);
% --------------------------------------------------------------------
%先位置置乱，再像素置乱
function locationpixelEncryption_Callback(hObject, eventdata, handles)
if handles.loadImage==0
    warndlg('请选择图像！');
    return;
end

imgDst=imread(handles.imagePath);
if size(imgDst,3)==3
    imgDst=rgb2gray(imgDst);
end

based=str2num(get(handles.haltonBased,'string'));
if based<=1 || based>=1000 || based~=fix(based)
    warndlg('参数应为(1,1000)之间的整数！');
    return;
end

imgDst=locationExchange(imgDst,based);          %先位置置乱
imgDst=pixelEncryption(imgDst,based);           %再像素置乱
axes(handles.imageDst);
imshow(imgDst);
set(handles.imageDst_text,'Visible','on');

axes(handles.imageDst_hist);
imhist(imgDst);
set(handles.imageDstHist_text,'Visible','on');
handles.EncryptionImage=imgDst;
handles.EncryptionWay=4;
handles.encryption=1;
msgbox('加密成功！','提示');

guidata(hObject, handles);
% --------------------------------------------------------------------
%载入图像
function openFile_Callback(hObject, eventdata, handles)
[file_name,path_name]=uigetfile('*.bmp;*.jpg;*.png;*.jpeg;*.tif;*.gif','选择图像');
if (file_name==0)                                     	%非法路径
    warndlg('请选择图像！');
    handles.loadImage=0;                              	%载入失败
    return;
end

handles.imagePath=fullfile(path_name,file_name);    	%合成路径，读取源图像
handles.loadImage=1;                                  	%载入成功
imgSrc=imread(handles.imagePath);
if size(imgSrc,3)==3
    imgSrc=rgb2gray(imgSrc);
end

axes(handles.imageSrc);
imshow(imgSrc);
set(handles.imageSrc_text,'Visible','on');

axes(handles.imageSrc_hist);
handles.imageSource=imgSrc;                             %原始图像
imhist(imgSrc);
set(handles.imageSrcHist_text,'Visible','on');

guidata(hObject,handles);
% --------------------------------------------------------------------
%退出系统
function exitSystem_Callback(hObject, eventdata, handles)
inf=questdlg('是否退出？','关闭软件','是','否','是');  	 %退出时的提示信息
if strcmp(inf,'是')
    clear all;
    close all;                                      	%关闭所有窗口
end

% --------------------------------------------------------------------
function imageEncryption_CreateFcn(hObject, eventdata, handles)

% --------------------------------------------------------------------
function author_Callback(hObject, eventdata, handles)
msgbox(['Copyright (C) 2016 xxx'],'作者信息');

% --------------------------------------------------------------------
function safetyAnalysis_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function imgHist_Callback(hObject, eventdata, handles)
msgbox('图像直方图已开启！','提示');

% --------------------------------------------------------------------
function unEncryption_Callback(hObject, eventdata, handles)
if handles.loadImage==0
    warndlg('请选择图像！');
    return;
end
if handles.encryption==0
    warndlg('请先加密图像！');
    return;
end
based=str2num(get(handles.haltonBased,'string'));
if based<=1 || based>=1000 || based~=fix(based)
    warndlg('参数应为(1,1000)之间的整数！');
    return;
end
EncryWay=handles.EncryptionWay;
imgDst=handles.EncryptionImage;
if EncryWay==1                                  %位置置乱
    imgDst=locationUnExchange(imgDst,based);
elseif EncryWay==2                              %像素置乱
    imgDst=pixelUnEncryption(imgDst,based);
elseif EncryWay ==3                             %先位置置乱，后像素置乱
    imgDst=pixelUnEncryption(imgDst,based);     %先解密像素
    imgDst=locationUnExchange(imgDst,based);    %再解密位置
elseif EncryWay==4                              %先像素置乱，后位置置乱
    imgDst=locationUnExchange(imgDst,based);    %先解密位置
    imgDst=pixelUnEncryption(imgDst,based);     %再解密像素
end

handles.unEncryptionImage=imgDst;               %解密后图像
axes(handles.imageUnEncryption);
imshow(imgDst);
set(handles.imageUnEncryption_text,'Visible','on');

axes(handles.imageUnEncryption_hist);
imhist(imgDst);
set(handles.imageUnEncryptionHist_text,'Visible','on');

guidata(hObject,handles);

% --------------------------------------------------------------------
%相关性分析
function correlationAnalysis_Callback(hObject, eventdata, handles)
if handles.encryption==0
	warndlg('请先加密图像！');
    return;
end

imgSrc=handles.imageSource;         %原始图像
imgEnc=handles.EncryptionImage;     %加密图像
imgUnE=handles.unEncryptionImage;   %解密图像

[rows,clos]=size(imgSrc);

totalNumber=1000;                                       %随机采样点个数
edgeDist=10;                                            %避免下标越界

randX=ceil((rows-edgeDist)*rand(totalNumber,1))+1;
randY=ceil((clos-edgeDist)*rand(totalNumber,1))+1;

plot1X=randX;
plot1Y=randY;
plot2X=randX;
plot2Y=randY;
plot3X=randX;
plot3Y=randY;
%------------------------------------------------------------------
%相邻像素水平相关性
for i=1:totalNumber
    plot1X(i,1)=imgSrc(randX(i,1),randY(i,1));
    plot1Y(i,1)=imgSrc(randX(i,1),randY(i,1)+1);
   	plot2X(i,1)=imgEnc(randX(i,1),randY(i,1));
    plot2Y(i,1)=imgEnc(randX(i,1),randY(i,1)+1);
   	plot3X(i,1)=imgUnE(randX(i,1),randY(i,1));
    plot3Y(i,1)=imgUnE(randX(i,1),randY(i,1)+1);
end

axes(handles.beforeEncryptionCorr);         %原始
plot(plot1X,plot1Y,'.');
set(handles.beforeEncryptionCorr_text,'Visible','on');
%------------------------------------------------------------------
axes(handles.afterEncryptionCorr);          %加密
plot(plot2X,plot2Y,'.');
set(handles.afterEncryptionCorr_text,'Visible','on');
%------------------------------------------------------------------
axes(handles.unEncryptionCorr);             %解密
plot(plot3X,plot3Y,'.');
set(handles.unEncryptionCorr_text,'Visible','on');
guidata(hObject,handles);

% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Encryption_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
web https://www.baidu.com/

% --------------------------------------------------------------------
function Contact_Callback(hObject, eventdata, handles)
web https://www.baidu.com/

% --------------------------------------------------------------------
function haltonBased_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function haltonBased_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
