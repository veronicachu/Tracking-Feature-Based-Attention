% function H = corttopo(data,hm,varargin)
%
% Plots a 2-dimensional topography of given data using the supplied or
% named headmodel. If the data is complex, this calls complextopo.m
% instead. There are many options (described below) for how you want the
% topo plot to be drawn.  
%
% If the area outside the circle is not tranparent, you are not using the 
% OpenGL renderer.  Only OpenGL supports tranparency.  If you encounter
% drawing errors in an OpenGL figure (e.g. text now showing up, axis boxes
% not bein drawn, etc) try running opengl in software mode.
%
% Output (optional):
%   H - structure with handles and interpolated data
%
% Required Input:
%   data - the data vector to plot (nchans x 1)
%   hm - a headmodel with 3D channel positions following Siyi's structure.
%        Example headmodels can be found in egihm.mat and antwavehm.mat.
%        Alternatively, you can pass a string with the name of an existing
%        system that has a headmodel, such as 'egi128' or 'antwave'
%
% Optional Inputs: (default values)
%   plotaxes - axes in which to create plot (current axes)
%   badchans - use this or goodchans, not both ([])
%   goodchans - use this or badchans, not both ([])
%
%   Color Options
%   drawcolorbar - toggles drawing a colorbar (0)
%   cmap - the colormap to use ('jet')
%   clim - length 2 vector that sets the caxis limits (auto)
%   weights - uses the colormap hotncold and sets the clim equal to
%             [-1 1]*max(abs(data)). Useful for plotting channel weights
%             of ICA components or topos of condition differences. (0)
%
%   Electrode Options
%   drawelectrodes - draw electrodes on the head (1)
%   drawoutliers - draw the electrodes far outside the circle (0)
%   channumbers - draws channel numbers instead of dots (1)
%   chanfontsize - fontsize for channel numbers (10)
%   markbadchans - draws bad electrodes dark (1)
%   goodelectcolor - triplet color for the good electrodes ([.9,.9,.9])
%   badelectcolor - triplet color for the bad electrodes ([.2,.2,.2])
%
%   Contour Options
%   drawcontours - toggles drawing contour lines (0)
%   ncontours - number of countour lines (6)
%
%   Advanced Options
%   nPixel - resolution of the plot (256)
%   electrodeWidth - possibly lower this for high density recordings (.01)
%

function HH = corttopo(data,hm,varargin)
% Version History:
%   1.0 - Originally adapted from Siyi Deng's topohead2d.m   All further
%          revisions by Cort Horton
%   1.1 - Fixed errors with plotaxes, head models, alpha mapping
%   1.2 - Added features: weights flag, bad channel marking
%   1.3 - No longer hard-coded to a recording environment. Headmodel is
%          now expected as an input
%   1.4 - Can now plot channel numbers instead of dots
%   1.5 - Allowed faux transparency with non-opengl rendereres by setting
%          the lowest colormap value to the figure background color. Also
%          added the ability to name a headmodel to use.  7/12/13
%   1.6 - Changed name of function to reduce confusion with Bill's topo
%         plotting functions. Also now calls complextopo when it detects
%         complex data. 7/14/13
%   1.7 - Removed faulty faux tranparency features 6/12/14

% Transposes data into column vector if needed
if size(data,1)==1; data=data'; end;

% Detects complex input and calls complextopo.m instead
if ~isreal(data);
    H = complextopo(data,hm,varargin{:});
else
    % Parse inputs;
    [~,nPixel,cmap,badchans,goodchans,drawcontours,ncontours,drawelectrodes,...
        drawoutliers,channames,chanfontsize,markbadchans,goodelectcolor,...
        badelectcolor,drawcolorbar,plotaxes,weights,electrodeWidth,clim] = ...
        parsevar(varargin,'nPixel',256,'cmap',[],'badchans',[],'goodchans',[],...
        'drawcontours',0,'ncontours',6,'drawelectrodes',1,'drawoutliers',0,...
        'channumbers',1,'chanfontsize',10,...
        'markbadchans',1,'goodelectcolor',[1 1 1],'badelectcolor',[.3 .3 .3],...
        'drawcolorbar',0,'plotaxes',gca,'weights',0,'electrodeWidth',.01,...
        'clim',[]);
    
    % Default colormaps
    if weights && isempty(cmap);
        cmap='warmncold';
    elseif isempty(cmap);
        cmap='jet';
    end
    
    % loads a named headmodel
    if ischar(hm);
        tmp=load([hm 'hm']);
        fn=fieldnames(tmp);
        hm=getfield(tmp,fn{1});
    end
    
    % Check for matching channel numbers
    if length(data) ~= size(hm.Electrode.CoordOnSphere,1);
        error('Size of input data does not match chans in headmodel');
    end
    
    % Resolve good and bad channel lists
    nchans=length(data);
    if isempty(goodchans) && isempty(badchans);
        goodchans=1:nchans;
    elseif isempty(goodchans) && ~isempty(badchans);
        goodchans=setdiff(1:nchans,badchans);
    elseif ~isempty(goodchans) && isempty(badchans);
        goodchans=intersect(1:nchans,goodchans);
        badchans=setdiff(1:nchans,goodchans);
    elseif ~isempty(goodchans) && ~isempty(badchans);
        error('Use a goodchan list or a badchan list, not both');
    end
    badchans(badchans > nchans) = [];
    
    % Other preprocessing
    es = hm.Electrode.CoordOnSphere;
    H = struct;
    if size(data,1)==1;
        data=data';
    end
    
    % Remove bad channels;
    data(badchans) = [];
    es(badchans,:) = [];
    
    % Data interpolation from 3D to 2D
    [xi,yi,zi] = plane2ball(nPixel,hm.Electrode.SphereExtendAngle,'AED');
    vi = interpolate3d(es,data,[xi(:),yi(:),zi(:)],electrodeWidth);
    
    % Restrict image to a disc; get the range of data;
    diameter= nPixel;
    vi(logical(1-discmask(nPixel,diameter-2))) = NaN;
    vi = reshape(vi,nPixel,nPixel);
    H.Data=vi;
    
    % Get limits of the data
    dataRange = [min(min(vi)) max(max(vi))];
    
    % Prepare the figure and axes;
    H.Axes=plotaxes;
    cla(H.Axes);
    axis(H.Axes,'equal','off');
    hold(H.Axes,'on');
    
    % Construct the colormap;
    if ischar(cmap);
        c = eval([cmap '(256);']);
    else
        c=cmap;
    end
    
    % Set the colormap
    H.Colormap = c;
    colormap(H.Axes,H.Colormap);
    
    % Draw the interpolated data
    H.Image = image(vi,'Parent',H.Axes,'CDataMapping','scaled');
    
    % Set the color axis
    if isempty(clim)
        if weights
            clim=[-1.05 1.05]*max(abs(dataRange));
        else
            clim=dataRange;
        end
    end
    caxis(H.Axes,clim);
    
    % Draw the colorbar;
    if drawcolorbar
        H.Colorbar = colorbar;
    end
    
    % Draw contour lines;
    if drawcontours
        H.ContourStep = linspace(dataRange(1),...
            dataRange(2),ncontours);
        [~,H.ContourLow] = ...
            contour(H.Data,H.ContourStep(1:ceil(ncontours/2)),...
            'LineStyle','--','color',[0.2,0.2,0.2]);
        [~,H.ContourHigh] = ...
            contour(H.Data,...
            H.ContourStep(ceil(ncontours/2+1):ncontours),...
            'LineStyle','-','color',[0.2,0.2,0.2]);
    end
    
    % Draw the ear and nose sketch;
    [x,y] = pol2cart([linspace(-pi/4,pi/4,20);...
        linspace(0.75*pi,1.25*pi,20)],diameter/6);
    y = y+nPixel/2;
    x = x+nPixel/2+sign(x)*6*diameter/16+1/2;
    H.Ears = plot(H.Axes,x',y','k-','linewidth',3);
    x = linspace(-nPixel/10,nPixel/10,20);
    y = nPixel*cos(x*5*pi/nPixel)/12+nPixel-1-ceil((nPixel-diameter)/2);
    x = x+nPixel/2;
    H.Nose = plot(H.Axes,x,y,'k-','linewidth',3);
    
    [x,y] = pol2cart(linspace(-pi/2,1.5*pi,128),diameter/2-1);
    H.Ring = plot(H.Axes,x+nPixel/2+0.5,y+nPixel/2+0.5,'k-','linewidth',3);
    
    % Transparency effects
    H.Mask = isnan(vi);
    set(H.Image,'AlphaData',double(~H.Mask));
    
    % Draw electrodes;
    if drawelectrodes
        [x,y] = ball2plane(hm.Electrode.CoordOnSphere(:,1),...
            hm.Electrode.CoordOnSphere(:,2),hm.Electrode.CoordOnSphere(:,3));
        
        if ~drawoutliers
            outlier = ((x.^2+y.^2) > 1.05*hm.Electrode.Scaling2D^2/4);
            x(outlier) = NaN;
            y(outlier) = NaN;
        end
        
        x = x*nPixel/hm.Electrode.Scaling2D+nPixel/2;
        y = y*nPixel/hm.Electrode.Scaling2D+nPixel/2;
        
        if channames
%             for c = 1:nchans, thestrings{c} = num2str(c); end;
            thestrings = hm.ChanNames;
            if markbadchans
                H.gctxt = text(x(goodchans),y(goodchans),ones(size(goodchans)),thestrings(goodchans),'Parent',H.Axes,...
                    'HorizontalAlignment','center');
                set(H.gctxt,'fontsize',chanfontsize,'fontweight','bold','color',goodelectcolor);
                H.bctxt = text(x(badchans),y(badchans),ones(size(badchans)),thestrings(badchans),...
                    'Parent',H.Axes,'HorizontalAlignment','center');
                set(H.bctxt,'fontsize',chanfontsize,'fontweight','bold','color',badelectcolor);
            else
                H.txt = text(x,y,ones(size(x)),thestrings);
                set(H.txt,'fontsize',chanfontsize,'fontweight','bold','color',goodelectcolor,'Parent',H.Axes,...
                    'HorizontalAlignment','center');
            end
        else
            if markbadchans
                H.GoodElectrode = plot(H.Axes,x(goodchans),y(goodchans),'Marker','o',...
                    'MarkerEdgeColor',goodelectcolor,...
                    'MarkerFaceColor',goodelectcolor,...
                    'MarkerSize',4,'LineStyle','none');
                H.BadElectrode = plot(H.Axes,x(badchans),y(badchans),'Marker','o',...
                    'MarkerEdgeColor',badelectcolor,...
                    'MarkerFaceColor',badelectcolor,...
                    'MarkerSize',4,'LineStyle','none');
            else
                H.Electrode = plot(H.Axes,x,y,'Marker','o',...
                    'MarkerEdgeColor',goodelectcolor,...
                    'MarkerFaceColor',goodelectcolor,...
                    'MarkerSize',4,'LineStyle','none');
            end
        end
    end
    
end

if nargout>0; HH=H; end