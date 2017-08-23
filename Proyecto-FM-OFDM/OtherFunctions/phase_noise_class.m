classdef phase_noise_class < handle
%  Copyright 2015, Per Zetterberg, Qamcom Research & Technology.
% Generate phase-noise samples modeling a PLL using the LTI phase domain
% approach. The model and parameters are described in the mmMagic document
% D5.1. Two settings are available "high" and "low". Custom settings can be
% obtained by manually setting the parameters Note that long continous
% phase-noise sequences by calling the generate_phase_noise methods
% repeatedly.
%cd 
% Constructor:  
% phase_noise_class(setting_string,fc,Ts,ref_seed,vco_seed,pll_seed,warmup)
% setting_string: "high" or "low", see above. 
% fc            : Carrier frequency of VCO output,
% Ts            : Sample interval (s).
% ref_seed      : Twister seed used to generate the REF phase noise (-1 for random).
% vco_seed      : Twister seed used to generate the VCO phase noise (-1 for random).
% pll_seed      : Twister seed used to generate the PLL phase noise (-1 for random).
% warmup        : If =1 (true) then eliminate first micro-seconds of
%               : samples to remove transient statistics (default).
%
% Method:
% p=generate_phase_noise(obj,Ns)
%
% Generates Ns samples. The results of two calls can be concatenated as e.g:
% m=phase_noise_class('low',20e9,1e-10,-1,-1,-1);
% p1=m.generate_phase_noise(1000); p2=m.generate_phase_noise(1000);
% p=[p1,p2];






    properties
        
        fc; % Carrier frequency
        Ts; % Inter-sample time
        ref_seed;
        pll_seed;
        vco_seed;
        
        % Parameters of loop filter designed according to Dean Banerjee,
        % "PLL performance, simulation and design". 4th Edition.
        BW;  zeta; filter_order;
        
        % Phase noise component specifications
        ref_fc; % The frequency of the clock.
        ref_PSD0;% The phase noise spectral density at 0Hz in dbc/Hz.
        ref_fp; % Frequency of pole in Hz.
        ref_fz; % Frequency of zero in Hz.
        vco_fc; % The carrier frequency use to specify the VCO. Not necessarily the same as fc.
        vco_PSD0; % The phase noise spectral density at 0Hz in dbc/Hz.
        vco_fp; % Frequency of pole in Hz.
        vco_fz; % Frequency of zero in Hz.
        pll_fc; % The carrier frequency at which the PLL phase noise is specificied.
        pll_PSD0; % The phase noise spectral density at 0Hz in dbc/Hz.
        pll_fp; % Frequency of pole in Hz (typically "infinity e.g 1e30").
        pll_fz; % Frequency of zero in Hz (typically "infinity e.g 1e60").
        pll_flicker_corner; % Frequency at which the 1/f noise of the PLL is equal
                              % to the thermal (flat noise). Set to zero to disable 1/f noise.
        state;                      
        warmup;
    
        % Intermediate results
        num_laplace_ref;
        denom_laplace_ref;
        num_laplace_vco;
        denom_laplace_vco;
        
         
    end
    
    methods
        function obj = phase_noise_class(setting_string,fc,Ts,ref_seed,vco_seed,pll_seed,warmup) 
                    
            if ~exist('ref_seed','var')
                ref_seed=-1;
            end;    
            if ~exist('vco_seed','var')
                vco_seed=-1;
            end;    
            if ~exist('pll_seed','var')
                pll_seed=-1;
            end;    
            if ~exist('warmup','var')
                warmup=1;
            end;    
            
            obj.fc=fc;
            obj.Ts=Ts;
            obj.ref_seed=ref_seed;
            obj.vco_seed=vco_seed;
            obj.pll_seed=pll_seed;
            obj.warmup=warmup;
        
            obj.state{2}=zeros(1,5);
            obj.state{3}=zeros(1,5);
            obj.state{5}=zeros(1,5);
            for i1=1:11
                obj.state{1}{i1}=[];
                obj.state{4}{i1}=[];
                obj.state{6}{i1}=[];
            end;
 
            % DEFINICION DE PARÁMETROS
            switch lower(setting_string)
                case 'high'
                    obj.ref_fc=51.84e6;
                    obj.ref_fp=1;
                    obj.ref_fz=3.98e3;
                    obj.ref_PSD0=-80;
                    obj.pll_PSD0=-95;
                    obj.pll_fz=1e60;
                    obj.pll_fp=1e30;
                    obj.pll_flicker_corner=800e3;             
                    obj.pll_fc=23.32e9;  
                    obj.filter_order=2;
                    obj.zeta=1.0;
                    obj.BW=400e3;
                    obj.vco_PSD0=19+5;
                    obj.vco_fp=1;
                    obj.vco_fz=80e6;
                    obj.vco_fc=23.32e9;             
                case 'low'    
                    
                    %  NEL TCXO 100MHz
                    % http://www.nelfc.com/pdf/0719c.pdf
                    obj.ref_fc=100e6;
                    obj.ref_fp=1;
                    obj.ref_fz=10e3;
                    obj.ref_PSD0=-80;
                    
                    % EPSON 4513C
                    %obj.ref_fc=491.52e6;
                    %obj.ref_fp=1;
                    %obj.ref_fz=200e3;
                    %obj.ref_PSD0=-110+60;
                    
                                        
                    obj.pll_PSD0=-113;
                    obj.pll_fz=1e60;
                    obj.pll_fp=1e30;
                    obj.pll_flicker_corner=2e6;             
                    obj.pll_fc=23.32e9;  
                    obj.filter_order=3;
                    obj.zeta=1.0;
                    obj.BW=1e6;         
                    obj.vco_PSD0=19-10-6;
                    obj.vco_fp=1;
                    obj.vco_fz=20e6;
                    obj.vco_fc=23.32e9;       
                otherwise
                    disp('This setting is undefined')
            end
          
           obj.set_filter_parameters();
               
              
         end;
         function [nom_laplace_ref,denom_laplace_ref,nom_laplace_vco,denom_laplace_vco]=set_filter_parameters(obj,BW,filter_order,zeta)
                             
                % Design PLL filter. Based on "PLL performance, simulation and design",
                % Dean Banerjee, 4th Edition
                
                if ~exist('BW','var') | isempty(BW)
                    BW=obj.BW;
                end;
                if ~exist('filter_order','var') | isempty(filter_order)
                   filter_order=obj.filter_order;
                end;
                if ~exist('zeta','var') | isempty(zeta)
                   zeta=obj.zeta;
                end;
                
                obj.BW=BW;
                obj.filter_order=filter_order;
                obj.zeta=zeta;
                            
                N=1; % The result is independent of N and K (except for scaling with N). 
                K=1; % We keep them anyway to make the equations align with Banerjee's book.
                %zeta=0.85993;
                wn=2*pi*BW/(2*zeta);
                A0=K*inv(wn*wn);
                T2=2*zeta/wn;
   
                T1=inv(BW*4.055*2*pi);
                T3=inv(BW*8.945*2*pi);
                T4=inv(BW*27.66*2*pi);
        
                if (filter_order==3)
                  T4=0;
                elseif (filter_order==2)
                  T3=0; T4=0;        
                elseif (filter_order==4)
                    % Already done
                else
                    error(['Filter order ',num2str(filter_order),' not implemented']); 
                end;
    
                A1=A0*(T1+T3+T4);
                A2=A0*(T1*T3+T1*T4+T3*T4);
                A3=A0*(T1*T3*T4);
    
                C1=K*N*T2; C0=K*N;
                B5=A3; B4=A2; B3=A1; B2=A0; B1=K*T2; B0=K;    
                D5=A3; D4=A2; D3=A1; D2=A0; D1=K*T2; D0=K;

                obj.num_laplace_ref=[C1,C0];
                obj.denom_laplace_ref=[B5,B4,B3,B2,B1,B0];
                obj.num_laplace_vco=[A3,A2,A1,A0,0,0];
                obj.denom_laplace_vco=[D5,D4,D3,D2,D1,D0];
    
                if (filter_order==3)
                    obj.denom_laplace_ref=obj.denom_laplace_ref(2:end);
                    obj.denom_laplace_vco=obj.denom_laplace_vco(2:end);
                    obj.num_laplace_vco=obj.num_laplace_vco(2:end);              
                end;
                if (filter_order==2)
                    obj.denom_laplace_ref=obj.denom_laplace_ref(3:end);
                    obj.denom_laplace_vco=obj.denom_laplace_vco(3:end);
                    obj.num_laplace_vco=obj.num_laplace_vco(3:end);
                end;    

                obj.BW=BW;
                obj.filter_order=filter_order;
                obj.zeta=zeta;
        
                %nom_laplace_loop=[T2*K/N,K/N];
                %denom_laplace_loop=[A3,A2,A1,A0,0,0];    
                
                if (obj.warmup)
                    obj.generate_phase_noise(ceil(100e-6/obj.Ts));
                end;

         end;    
         
         function p=generate_phase_noise(obj,Ns)          
         % function p=generate_phase_noise(obj,Ns)
         % obj: Object of type phase_noise_class. 
         % p  : The output phase noise in complex format (exp(j phase_noise_angle)).

         
            [p1,end_state_ref]=phase_noise_source(Ns,obj.Ts,obj.fc,obj.ref_PSD0,obj.ref_fc,....
              obj.ref_fp,obj.ref_fz,0,0,obj.ref_seed,obj.state{1});
            [p1,end_state_filt1]=conv_with_laplace2(obj.num_laplace_ref,obj.denom_laplace_ref,p1,obj.Ts,obj.state{2});


            [p2,end_state_pll]=phase_noise_source(Ns,obj.Ts,obj.fc,obj.pll_PSD0,obj.pll_fc,....
             obj.pll_fp,obj.pll_fz,obj.pll_flicker_corner,1,obj.pll_seed,obj.state{6}); 
            [p2,end_state_filt2]=conv_with_laplace2(obj.num_laplace_ref,obj.denom_laplace_ref,p2,obj.Ts,obj.state{3});
            
          
            [p3,end_state_vco]=phase_noise_source(Ns,obj.Ts,obj.fc,obj.vco_PSD0,obj.vco_fc,...
             obj.vco_fp,obj.vco_fz,0,0,obj.vco_seed,obj.state{4});
             [p3,end_state_filt3]=conv_with_laplace2(obj.num_laplace_vco,obj.denom_laplace_vco,p3,obj.Ts,obj.state{5});

            p=exp(j*(p1+p2+p3));
    
            obj.state{1}=end_state_ref;
            obj.state{2}=end_state_filt1;
            obj.state{3}=end_state_filt2;
            obj.state{4}=end_state_vco;
            obj.state{5}=end_state_filt3;
            obj.state{6}=end_state_pll;
     
            if ~(obj.ref_seed==-1)
                obj.ref_seed=obj.ref_seed+1;
            end;          
            if ~(obj.pll_seed==-1)
                obj.pll_seed=obj.pll_seed+1;
            end;
            if ~(obj.vco_seed==-1)
                 obj.vco_seed=obj.vco_seed+1;
            end;       
         end; 

      end
      methods(Static)
        function  P=plotting_phase_noise(y,Ts,F,clr)
        %
        % Produces a classical phase-noise spectrum plot based on the measurements
        % of the complex valued measurement y.
        % The color of the plot lines is provided by the string argument clr
        % which can be set to e.g. 'g' for green lines.
        % If clr is not provided then no plot is generated, but the outpFut
        % values are still provided. This is useful when generating multiple
        % data sets.
        %
        %   P: Vector. The n:th element is the power of the nth bin with center
        %              frequency F(n).
        %
        %   y: Input signal.
        %  Ts: Sample interval.
        %   F: Vector of sample frequencies.
        % clr: Color of the plot.
        %
   
        if (size(y,2)>1)
            y=y.';
        end;

        f0=0;
        Nf=length(F);
        P=zeros(size(Nf));

        for i1=1:Nf
            f=f0+F(i1);
            BW=F(i1)*0.1;
            tmax_required=inv(BW)*10;    
            Ns=max(ceil(tmax_required/Ts));
            t=(-Ns:Ns)*Ts+1e-13;
            h=sin(pi*BW*t)./t; % Bandpass filter with bandwidth BW
            h=h/sum(h);
            %correction=sum(abs(h).^2)/(BW*Ts);
            if (length(y)<length(t))       
                warning(['To short measurement time for f=',num2str(f),' Hz']);
                Ns=floor((length(y)-1)/2);
                t=(-Ns:Ns)*Ts+1e-13;
                h=sin(pi*BW*t)./t; % Bandpass filter with bandwidth BW
                h=h/sum(h);
                %correction=sum(abs(h).^2)/(BW*Ts);        
            end;
            temp=exp(-j*2*pi*f*t').*y(1:min(end,length(t)));
            h=h/sqrt(sum(abs(h).^2));
            P(i1)=Ts*abs(h*temp)^2/abs(h*h');
    
        end;

        if exist('clr')
            semilogx(F,10*log10(P),clr)
        end;
          
     end;
   end;
end

function [n,end_state]=phase_noise_source(Ns,Ts,fc,s_PSD0,s_fc,s_fp,s_fz,s_flicker_corner,s_alpha,s_seed,begin_state)
%
% 
% Phase noise contributor.
%
%
% y=inv(s+a)x
%
% y'+a*y=x  D(exp(a*t)*y)=x*exp(a*t) <=> y= exp(-a*t) * \int_{-infty}^{t} exp(a*t) x dt
% y = exp(-a(t-t0+t0)) * \int_{-infty}^{t-t0+t0} exp(a*t) x dt
%   = exp(-a(t-t0)) exp(-a t0) ( \int_{-infty}^{t-t0} exp(a*t) x dt + \int_{t0}^{t}exp(a*t) x dt )=
%   = exp(-a(t-t0)) y0 +  exp(-a(t-t0)) \int_{t0}^{t} exp(a*(t-t0)) x dt
%   \approx  exp(-a(t-t0)) y0 + inv(a) *  (1-exp(-a*(t-t0))) x
%
% y = 1 /(1+jf/fa) x = fa / (fa+jf) x =  2 pi fa / (2 pi fa + j 2pi f)
%
% y = (1 + jf/fz) / (1 + jf/fa) =  (1 + fa/fz j f/fa) / (1 + j f/fa) =
%   = (1 + fa/fz ( 1 + j f/fa) ) - fa/fz) / (1 + j f/fa) = 
%   = (1-fa/fz)/ ( 1 + j f/fa) + fa/fz 
%



% y = y0 + inv(a) \exp(a*T)
% -C=1 + (1/a) *exp(a*T)*x dt

% H(s) = sqrt(S_PSD0)* (1+ s/(2 pi fz))/(1+s/(2 pi fp)) = 
%      = sqrt(S_PSD0)* (1-fp/fz   + fp/fz (1+ s/(2pi fp)))/(1+s/(2 pi fp))
%      = sqrt(S_PSD0)* (1-fp/fz)* / (1+s/(2 pi fp)) + sqrt(S_PSD0)*fp/fz
%      = sqrt(S_PSD0)*2*pi*fp*(1-fp/fz)/(2*pi*fp+s) + sqrt(S_PSD0)*fp/fz


if (s_seed==-1)
  rng('shuffle');    
else
  rng(s_seed);
end;

 


if (s_flicker_corner>0)
    % Approximate 1/p^alpha noise by a filtering white noise through a 
    % series of (1+f/p^2) / (1+f^2/z^2) filters
    % poles given by the vector p and zeros by the vector z.
    % Based on paper: https://hal.inria.fr/file/index/docid/294587/filename/oofa.pdf

    alpha=s_alpha; 
    dp=1.0;
    %p=10.^(2:dp:7);
    p=s_flicker_corner.*(10.^(-4:dp:1));
    
    
    z=p*10^(0.5*alpha*dp);
    % P=ones(size(F));  
 
    
    %  PSD of other noise sources at flicker_corner
    PSD_f=s_PSD0  + 10*log10(  (1+s_flicker_corner^2/s_fz^2)/(1+s_flicker_corner^2/s_fp^2));
    PSD_f=PSD_f+20*log10(fc/s_fc);
    PSD_f0 = PSD_f + 10*log10(1+s_flicker_corner/p(1));
           
    Nfft=2^24;
    P0a=zeros(size(1,Nfft));
    P0b=P0a;
    df=inv(Ts)/Nfft;
    
    C=-exp(-2*pi*p(1)*Ts);    
    D=inv(2*pi*p(1))*(1+C);    
    const=2*pi*p(1)*fc/s_fc;

    
    noise_alpha_in=sqrt(inv(Ts))*randn(1,Ns)*sqrt(10^(0.1*PSD_f0));
    [noise_alpha,end_state_temp]=filter(D,[1,C],noise_alpha_in,begin_state{2});
    end_state{2}=end_state_temp;
    
    noise_alpha=const*noise_alpha;        
    noise_alpha=(1-p(1)/z(1))*noise_alpha+p(1)/z(1)*noise_alpha_in;
    tentative_psd_at_flicker_corner=PSD_f0+10*log10((1+s_flicker_corner^2/z(1)^2)/(1+s_flicker_corner^2/p(1)^2));  

    for i20=2:length(p)
    
        C=-exp(-2*pi*p(i20)*Ts);    
        D=inv(2*pi*p(i20))*(1+C);

        tentative_psd_at_flicker_corner=tentative_psd_at_flicker_corner+...
            10*log10((1+s_flicker_corner^2/z(i20)^2)/(1+s_flicker_corner^2/p(i20)^2));  
        
        noise_alpha_in=noise_alpha;
        
        [noise_alpha,end_state_temp]=filter(D,[1,C],noise_alpha_in,begin_state{i20+1});  
        end_state{i20+1}=end_state_temp;
        
        noise_alpha=noise_alpha*2*pi*p(i20);
        if (i20<length(p))
          noise_alpha=(1-p(i20)/z(i20))*noise_alpha+p(i20)/z(i20)*noise_alpha_in;
        end;
    end;

    noise_alpha=noise_alpha*10^(0.05*(PSD_f-tentative_psd_at_flicker_corner));    
    %Pb=abs(fft(noise_alpha,Nfft)).^2/length(noise_alpha_in);
    %P0b=P0b/Nfft;
    %P0b=P0b/df;
       
 end;
 

 
C=-exp(-2*pi*s_fp*Ts);
D=inv(2*pi*s_fp)*(1+C);
const=2*pi*sqrt(10^(0.1*s_PSD0))*s_fp*(1-s_fp/s_fz)*fc/s_fc;
[n_f2,end_state_temp]=filter(D,[1,C],sqrt(inv(Ts))*randn(1,Ns),begin_state{1});  %% 1/f^2 noise.
end_state{1}=end_state_temp;
n_f2=n_f2*const;

%Nfft=2^24;
%df=inv(Ts)/Nfft;
%P=abs(fft(n_f2,Nfft)).^2/length(n_f2)/(Nfft*df);
%semilogx(((1:Nfft)-0.0*Nfft)/Nfft*inv(Ts),20*log10(P))



% Noise floor
%n=sqrt(10^(0.1*s_PSD0))*fc/s_fc*s_fp/s_fz*inv(sqrt(Ts))*randn(1,Ns);
n=inv(sqrt(Ts))*sqrt(10^(0.1*s_PSD0))*s_fp/s_fz*fc/s_fc*randn(1,Ns);

n=n+n_f2;

if (s_flicker_corner>0)
  n=n+noise_alpha;
end;



end


function [y,end_state]=conv_with_laplace2(B,A,x,Ts,begin_state)
%
% Convolve discrete time signal x sampled with interval Ts,
% with the impulse response continous time filter
%
%  H(s)= (B(1)s^(N-1),...,B(N))/(A(1)s^(M-1),...,A(M))
%


dt=Ts;
[direct_term,poles,coeffs]=poles_etc(B,A);
end_state=begin_state;

y=direct_term*x;

% Y=inv(s+a)X   <==> s*Y+a*Y=X <==> s*Y=X-a*Y <==> (y(n)-y(n-1))/dt=X-a*Y
% <==> y(n)=y(n-1)+dt*x(n)-dt*a*y(n-1)=(1-d*ta)*y(n-1)+dt*x(n)

% 
% y'+a*y=x  D(exp(a*t)*y)=x*exp(a*t) <=> y= exp(-a*t) * \int exp(a*t) x dt
% y = y0 + inv(a) \exp(a*T)
% -C=1 + (1/a) *exp(a*T)*x dt

for i1=1:length(coeffs)
    %C=-1-poles(i1)*dt;
    C=-exp(+poles(i1)*dt);
    %D=dt;
    D=-(1-exp(+poles(i1)*dt))/poles(i1);
    [temp1,temp2]=filter(D,[1,C],x,begin_state(i1));
    y=y+coeffs(i1)*temp1;
    end_state(i1)=temp2;
end;
y=real(y);


end % conv_with_laplace


function [direct_term,poles,coefficients]=poles_etc(B,A)
        %
        % Decompose H(s) as:
        % H(s)=direct_term+coefficients(1)*(s-poles(1))+...
        %   coefficients(1)*(s-poles(M));
        
        if (length(B)==length(A))
            if ~(B(1)==0)
                C=B-A*B(1)/A(1);
                C=C(2:end);
                [dummy,poles,coefficients]=poles_etc(C,A);        
                direct_term=B(1)/A(1);
                return;
            end;
        end;
    
        direct_term=0;
        K=A(1);
        A=A/K;
        R=roots(A);
        coeffs=zeros(size(R));

        for i1=1:length(coeffs)
            d=1;
            root1=R(i1);
            n=0;
            for i2=1:length(B)
                n=n+B(i2)*(root1^(length(B)-i2));  
            end;
            for i2=1:length(coeffs)        
                if ~(i1==i2)
                    root2=R(i2);
                    d=d*(root1-root2);
                end;
            end; %i2
       
          
            coeffs(i1)=n/d;
        end; % i1
        poles=R;
        coefficients=coeffs*inv(K);
end % poles_etc
