function FG_save_figure(name,handle)

% way 1: save as
saveas() ;  % it use 'print' command inside
            % saveas(gca,filename,fileformat)

% way 2: print
````````````% print(dformat,rnum,fname)
            % print�������������plot����֮��ʹ��

% way 3: getframe
a=getframe(handle) ;
% a=getframe(gca/gcf) ;
imwrite(a,name)


% �����ҪͼƬ����ʾ��ֱ�ӱ���
set(figure(1),'visible','off');

