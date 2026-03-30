classdef Awesome_DE_MS_Metaoptimizer < rl.agent.CustomAgent
% Algorithm generation-mutation strategy generation
% python-LLM as meta-optimizer, being trained via EL.
% DE as base-optimizer, with mutation strategy generation as opotimization object.

%------------------------------- Reference --------------------------------
% Yang, X., Wang, R., Li, K., Li, W., Huang, W., & Liu, W. (2026). Large 
% language model assisted meta-evolution for automated constrained optimization 
% evolutionary algorithm design. Expert Systems with Applications, 317, 131756. 
% https://doi.org/10.1016/j.eswa.2026.131756
%------------------------------- Copyright --------------------------------
% Copyright (c) 2025 EvoSys_NUDT Group. You are free to use the PlatMetaX
% for research purposes. All publications which use this platform or MetaBBO
% code in the platform should acknowledge the use of "PlatMetaX" and 
% reference "Xu Yang, Rui Wang, Kaiwen Li, Wenhua Li, Tao Zhang and Fujun He. 
% PlatMetaX: An Integrated MATLAB platform for meta-black-box optimization.
% https://doi.org/10.48550/arXiv.2503.22722".
%--------------------------------------------------------------------------
    properties
        metaTable
        metaObj
        indcount
        metapop
        metaNP = 5
        strategyCount
        proNum = 1
        epochIdx
    end
    
    methods
        function obj = Awesome_DE_MS_Metaoptimizer(observationInfo, actionInfo)
            obj = obj@rl.agent.CustomAgent();
%             addpath('E:\yx\toolbox\llmMatlab\llms-with-matlab')
            currentFilePath = mfilename('fullpath');
            [currentFolder, ~, ~] = fileparts(currentFilePath);
            if count(py.sys.path, currentFolder) == 0
                insert(py.sys.path, int32(0), currentFolder);
            end
            mod = py.importlib.import_module('testdeepseek');
            py.importlib.reload(mod);
            obj.ObservationInfo = observationInfo;
            obj.ActionInfo = actionInfo;

            obj.metaTable = struct('ind', [], 'fitness', []);
            for i = 1: obj.metaNP
                obj.metaTable(i).ind = i;
                obj.metaTable(i).fitness = -Inf;
            end
            obj.metapop = struct('ind', [], 'fitness', [], 'perfit', []);

            obj.strategyCount = 0;
            obj.indcount = 1;
            obj.epochIdx = 1;
            
        end
    end
    methods (Access = protected)
        function action = getActionImpl(obj,observation)
            curobj = [obj.metaTable.fitness];
            [~,maxidx]=max(curobj);
            action = obj.metaTable(maxidx).ind; 
        end
        function action = getActionWithExplorationImpl(obj, observation)
            obs = observation{1};
            proidx = obs(2);
            if proidx == 1
                obj.strategyCount = obj.strategyCount+1;
            end
            tempFile = [pwd '\BaseOptimizers\Single-objective optimization\Learned\Awesome_DE_MS_Baseoptimizer\updateFunc', num2str(obj.strategyCount), '.m'];
            if ~exist(tempFile, 'file') 
                response = py.testdeepseek.process_string(num2str(obj.strategyCount),obj.loadHistory());
                matlabCode = char(response);
                fid = fopen(tempFile, 'w');
                fprintf(fid, '%s', matlabCode);
                fclose(fid);
            end
            action = obj.strategyCount;   
        end
        function action = learnImpl(obj, experience)
            obs = experience{1}{1}; %obs
            curindID = obs(1);
            curproID = obs(2);
            strategyID = experience{2}{1}; %action
            obj.metapop(curindID).perfit(curproID) = experience{3};  %reward 
            obj.metapop(curindID).ind = strategyID;
            if experience{5}
                try
                    for i = 1:obj.metaNP
                        obj.metapop(i).fitness = sum([obj.metapop(i).perfit]);
                    end
                    for i = 1:obj.metaNP
                        [minFitV, minFitIdx] = min([obj.metaTable.fitness]);                     
                        if obj.metapop(i).fitness > minFitV
                            obj.metaTable(minFitIdx).fitness = obj.metapop(i).fitness;
                            obj.metaTable(minFitIdx).ind = obj.metapop(i).ind;
                        end
                    end
                catch ME
                    % 捕获错误并输出调试信息
                    disp('发生错误：');
                    disp(ME.message); % 输出错误信息
                    disp('错误发生在以下位置：');
                    disp(ME.stack(1)); % 输出错误位置
                end
            end
            action = obj.strategyCount;
        end  
        function history = loadHistory(obj)
            if obj.strategyCount <= 5
                history = "No history";
            else
                history = ['Current generation:',num2str(obj.epochIdx),'Current 5 best mutation strategies is:'];
                for i = 1:length(obj.metaNP)
                    updatefuncFileName = ['D:\MatlabPlatform\PlatMetaX\BaseOptimizers\Single-objective optimization\Learned\Awesome_DE_MS_Baseoptimizer\updateFunc', num2str(obj.metaTable(i).ind), '.m'];
                    history = strcat(fileread(updatefuncFileName), newline, 'The evolutionary algorithm with this mutation strategy solving multiple problems perfomrs with summary fitness increasing ',num2str(obj.metaTable(i).fitness),'than traditional DE (the bigger, the better)',newline);
                end
            end
        end

        function resetImpl(obj)
            
        end
    end
end
