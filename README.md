# LMCOEA: LLM-Assisted Meta-Evolution for Automated Constrained Optimization Evolutionary Algorithm Design
[![Paper](https://img.shields.io/badge/Paper-ESWA%202026-blue)](https://doi.org/10.1016/j.eswa.2026.131756)
[![GitHub](https://img.shields.io/badge/GitHub-LMCOEA-green)](https://github.com/yourusername/LMCOEA)

## 1. 代码介绍
本项目基于**元黑箱优化（MetaBBO）** 方法，实现约束优化进化算法的**全自动生成与设计**，无需人工干预即可为约束优化问题定制高效的进化算法更新规则。

### 核心技术
1. **大语言模型驱动的元层进化**：将大语言模型（LLM）作为元优化器的进化算子，替代人工设计算法规则，实现算法的自动化迭代生成；
2. **RTO2H提示词工程框架**：创新性引入RTO2H框架，有效整合历史优化经验、严格约束大语言模型生成行为、抑制模型幻觉问题，保障生成算法的**高质量、高正确性、高可执行性**；
3. **约束优化算法自动化设计**：聚焦约束优化进化算法（COEA）的核心更新规则，通过元黑箱优化的进化学习机制，在多类型约束优化问题上学习通用知识，提升生成算法的泛化能力。

本项目是论文 **Large language model assisted meta-evolution for automated constrained optimization evolutionary algorithm design** 的官方实现，为自动化算法设计提供了可扩展、数据驱动的全新解决方案。

### 引用论文
如果您在研究中使用了本代码，请引用以下论文：
```bibtex
@article{yang2026lmcoea,
title = {Large language model assisted meta-evolution for automated constrained optimization evolutionary algorithm design},
journal = {Expert Systems with Applications},
volume = {317},
pages = {131756},
year = {2026},
issn = {0957-4174},
doi = {https://doi.org/10.1016/j.eswa.2026.131756},
url = {https://www.sciencedirect.com/science/article/pii/S095741742600669X},
author = {Xu Yang and Rui Wang and Kaiwen Li and Wenhua Li and Weixiong Huang and Wei Liu},
keywords = {Meta-black-box optimization, Large language model, Constrained optimization evolutionary algorithm, Prompt design, Evolutionary computation},
abstract = {Meta-black-box optimization (MetaBBO) has been significantly advanced through the use of large language models (LLMs), yet in fancy on constrained optimization evolutionary algorithms (COEAs). On the meanwhile, generating completely correct and effective algorithmic code via LLMs remains challenging due to LLM hallucination and token limitation. To address this issue, the update rules of COEA become our study focus. An LLM-assisted meta-evolution based COEA, termed LMCOEA is proposed that iteratively leverages LLMs as the evolutionary strategy of meta-optimizer to generate update rules of COEAs without human intervention. This automated design is implemented via evolutionary learning based MetaBBO. The meta-optimizer learns knowledge across a diverse set of constrained optimization problems to enhance generalizability. RTO2H framework is also introduced for prompt engineering. Experimental results demonstrate that LMCOEA could design competitive update rules in terms of computational efficiency and solution accuracy compared with human-crafted rules. This work contributes to the field by providing a scalable and data-driven methodology for automated algorithm generation, while also highlighting limitations and directions for future work.}
}
```

## 2. 环境依赖
本代码**必须依赖 [PlatMetaX](https://github.com/yourusername/PlatMetaX) 元黑箱优化框架**运行，请先完成 PlatMetaX 的环境配置与部署。

## 3. 使用说明
### 核心功能：元训练（自动生成约束优化进化算法）
在 **PlatMetaX 命令行/脚本** 中执行以下命令，启动算法的自动化元训练流程：

```matlab
% 基础元训练命令
platmetax('task', @Train, 'metabboComps', 'Awesome_DE_MS', 'problemSet','BBOB2022LLM','N',50,'D',10)
```

### 可配置参数说明
你可以根据实验需求自由调整以下核心参数（其他请参考PlatMetaX平台使用规范）：
1. **训练集（problemSet）**
   - 示例：`BBOB2022LLM`（默认约束优化测试集）
   - 可替换为自定义约束优化问题集
2. **基层种群规模（N）**
   - 示例：`50`（默认值）
   - 用于控制底层进化算法的种群大小
3. **问题决策变量维度（D）**
   - 示例：`10`（默认值）
   - 适配不同维度的约束优化问题

### 自定义训练命令示例
```matlab
% 自定义：30维问题、种群规模100、使用自定义测试集
platmetax('task', @Train, 'metabboComps', 'Awesome_DE_MS', 'problemSet','CustomConstrainedSet','N',100,'D',30)
```

### 执行流程
1. 加载 PlatMetaX 框架；
2. 启动元层进化，调用大语言模型生成算法更新规则；
3. 在指定测试集上评估生成算法的性能；
4. 迭代优化，最终输出高性能的自动化约束优化进化算法。

## 4. 项目结构
```
LMCOEA/
├── src/                 # 核心代码实现
│   ├── llm_prompt/      # RTO2H提示词框架实现
│   ├── meta_optimizer/  # 元层进化算法核心逻辑
│   └── evaluator/       # 算法性能评估模块
├── examples/            # 元训练示例脚本
├── LICENSE
└── README.md
```

## 5. 许可证
本项目基于 MIT 许可证开源，仅供学术研究使用。

---

### 总结
1. 本项目实现**大语言模型辅助元进化**，全自动生成约束优化进化算法，核心依托元黑箱优化与RTO2H提示词框架；
2. 代码**依赖PlatMetaX平台**，通过指定命令即可启动元训练，支持自定义数据集、种群规模和问题维度；
3. 使用代码请严格按照提供的BibTeX格式引用原论文。
