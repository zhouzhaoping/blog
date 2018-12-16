---
title: 统计学习方法笔记
date: 2018-12-17 00:32:52
tags:
- 笔记
- 机器学习
categories: 机器学习
---

这是李航老师的《统计学习方法》的笔记，是我个人在阅读本书的时候的一些总结，权当参考，如有错误请指正。

<!-- more -->

## 第一章 统计学习方法概论
- 方法 = 模型 + 策略（loss/risk） + 算法
- loss：
	- 0-1 误差率
	- quadratic 最小二乘
	- absolute SVM
	- logarithmic 逻辑回归
	- exp Boosting
- 样本量很小的时候，经验风险（ERM）最小化容易导致过拟合，这时候需要结构风险最小化（SRM）
  <br> SRM = ERM + 模型复杂度的正则化项  
- 监督学习问题实质是ERM和SRM的最优化问题，即为目标函数
- 最小二乘法是求拟合多项式系数的唯一解
- L<sub>i</sub>范数||w||<sub>i</sub>：
	- L1范数是L0范数的最优凸近似，可以使参数稀疏
	- L2主要用于处理过拟合问题，让每个权重参数值小
	- L1会趋向于产生少量的特征，而其他的特征都是0，而L2会选择更多的特征，这些特征都会接近于0。
- 训练集训练模型，验证集模型选择，测试集对学习方法进行评估
- 交叉验证为了重复使用数据：
	- 简单
	- s-fold（训练s次测试s次求平均）
	- 留一（数据量较小）
- 监督学习分为生成方法和判别方法：
	- discrimitive学习联合概率分布P(x,y)，然后<img src="http://latex.codecogs.com/gif.latex?\frac{P(x,y)}{P(x)}"/>朴素贝叶斯和隐马尔科夫（可还原联合概率分布）
	- generative学习条件概率分布P(y|x)（数据到数据，不考虑过程）
- <img src="http://latex.codecogs.com/gif.latex?Precison=\frac{TP}{TP+FP}"/>
  <br><img src="http://latex.codecogs.com/gif.latex?Recall=\frac{TP}{TP+TN}"/>
  <br><img src="http://latex.codecogs.com/gif.latex?F_1=\frac{2}{P^{-1}+R^{-1}}"/>
- classifier、tagging、regression

## 第二章 感知机
- f(x) = sign(w·x+b)
<br>w超平面法向量，b截距
- 学习目标：求一个将正实例点和负实例点完全正确分开的分离超平面
- 损失函数：<img src="http://latex.codecogs.com/gif.latex?L(w,b)=-\sum_{x_i\in_M}y_i(w
\centerdot x_i+b)"/>
- 随机梯度下降法：任选一个超平面wb，然后选择某误分类点来对wb进行更新(减去步长乘以损失函数的梯度），<img src="http://latex.codecogs.com/gif.latex?0<\eta<=1"/>为学习率
<br>样本量更多所以选择随机梯度下降，精度低但是时间低
- 感知机算法的对偶形式：提前算好Gram矩阵
- 在线性不可分的时候会不收敛（凸包相交判定）

## 第三章 k近邻
- 惰性学习，不显示分类器
- <img src="http://latex.codecogs.com/gif.latex?y=arg \max_{c_j}\sum_{x_i\in_{N_k}(x)}I(y_i=c_j)"/>
- <img src="http://latex.codecogs.com/gif.latex?L_p(x_i,x_j)=\sum_{l=1}^n(|x_i^{(l)}-x_j^{(l)}|^p)^{\frac1p}"/>, p>=1
	- p=2,Euclidean
	- p=1,Manhattan
	- p=∞,各坐标距离最大
- k值选择：
	- 减小k则模型复杂，容易过拟合，估计误差大
	- 增大k则模型简单，近似误差大
	- 用交叉验证选取最优的k
- 多数表决规则等价于经验风险最小化
- kd树：提高k近邻搜索的效率
	- 构造：每个维按照中位数递归二分
	- 插入、删除：类似二叉树
	- 搜索：从找到的叶子节点回退到根节点，如果另一个子节点的对应区域和目前最小圆有交集，则递归检查该子节点
 
## 第四章 朴素贝叶斯
- 条件独立假设：特征都是条件独立的
- 朴素贝叶斯：<img src="http://latex.codecogs.com/gif.latex?y=arg \max_{c_k}P(Y=c_k)\prod_j P(X^{(j)}=x^{(j)}|Y=c_k)"/>
	- 其中先验（左）和条件（右）都能用极大似然估计求出
	- 即0-1损失时期望风险最小化
- 贝叶斯估计：避免要估计的概率为0
	- <img src="http://latex.codecogs.com/gif.latex?\lambda>=0"/>，为0则极大似然估计，为1则为拉普拉斯平滑
	- 先验：<img src="http://latex.codecogs.com/gif.latex?P_\lambda(Y=c_k)=\frac{\sum_{i=1}^NI(y_i=c_k)+\lambda}{N+K\lambda}"/>
	- 条件：<img src="http://latex.codecogs.com/gif.latex?P_\lambda(X^{(j)}=a_{jl}|Y=c_k)=\frac{\sum_{i=1}^NI(x_i^{(j)}=a_{jl},y_i=c_k)+\lambda}{\sum_{i=1}^NI(y_i=c_k)+S_j\lambda}"/>

## 第五章 决策树
- if-then规则，本质是从训练数据集中归纳出一组分类规则
- 信息增益
	- 熵：<img src="http://latex.codecogs.com/gif.latex?H(X)=-\sum_{i=1}^np_i\log p_i"/>
	- 条件熵（已知X的条件下Y的不确定性）：<img src="http://latex.codecogs.com/gif.latex?H(Y|X)=\sum_{i=1}^np_iH(Y|X=x_i)"/>
		- 当然选择最小的开始分类
	- 信.息增益（由于特征A使得对D分类的不确定性减少的程度）：<img src="http://latex.codecogs.com/gif.latex?g(D,A)=H(D)-H(D|A)"/>
	- 信息增益比：<img src="http://latex.codecogs.com/gif.latex?g_R(D,A)=\frac{g(D,A)}{H_A(D)}"/>
		- 矫正了特征值较多的偏向
	- ID3：选择信息增益最大的，如果特征已经遍历完或者信息增益小于阈值则为单节点
		- 相当于用极大似然法进行概率模型的选择（对决策树进行参数估计）
		- 只有树生成，容易发生拟合
	- C4.5：和ID3一样，但是选择信息增益比最大的
	- 剪枝：
		- 某结点经验熵（alpha越小则模型越复杂）：
		<br><img src="http://latex.codecogs.com/gif.latex?C_\alpha(T)=C(T)+\alpha|T|=\sum_{t=1}^{|T|}N_tH_t(T)+\alpha|T|"/>
		<br><img src="http://latex.codecogs.com/gif.latex?=-\sum_{t=1}^{|T|}\sum_{k=1}^KN_{tk}\log\frac{N_tk}{N_t}+\alpha|T|"/>
		- 计算每个节点经验熵，递归从叶节点回退，如果剪枝后的经验熵更小则选择剪枝
	- CART：**回归树用平方误差最小化原则（遍历特征和切分点算中心偏差），分类树用基尼指数最小化原则**
		- 基尼指数（平法误差最小化，越大则样本集合的不确定性越大） ：
		<br><img src="http://latex.codecogs.com/gif.latex?Gini(D)=1-\sum_{k=1}^{K}(\frac{|C_k|}{|D|})^2"/>
		<br><img src="http://latex.codecogs.com/gif.latex?Gini(D,A)=\frac{|D_1|}{|D|}Gini(D_1)+\frac{|D_2|}{|D|}Gini(D_2)"/>
		- 生成：对每个结点，递归地遍历每个特征及其每个取值，选择基尼指数最小的作为切分点，切分为二叉树的两个结点。直到样本小于阈值或者基尼系数小于阈值或者没有更多特征。
		- **剪枝（精髓没搞懂）**：用【有限个子树Tα】计算【无限个α】，然后再交叉验证

## 第六章 逻辑斯谛回归与最大熵模型**精髓没搞懂**
- logistic回归（分类问题）：
	- why阻塞增长模型?<img src="http://latex.codecogs.com/gif.latex?Y=\frac1{1+e^{-W^TX}}"/>
		- 概率需要<img src="http://latex.codecogs.com/gif.latex?Y\in (0,1)"/>
		- 在X=0处变化较快
		- 这个关系的公式要在之后形成的cost function是凸函数
	- 极大化似然函数进行w参数估计
		<br><img src="http://latex.codecogs.com/gif.latex?L(w)=\log (\prod_{i=1}^N[Y_W(X_i)]^yi[1-Y_W(X_i)]^{1-y_i})"/>
		<br>最优化用梯度下降或者拟牛顿法
	- 推广到K项逻辑斯谛回归
		<br><img src="http://latex.codecogs.com/gif.latex?P(Y=k|x)=\frac{\exp(w_k\cdot x)}{1+\sum_{k=1}^{K-1}\exp(w_k\cdot x)}"/>
		<br><img src="http://latex.codecogs.com/gif.latex?P(Y=k|x)=\frac{1}{1+\sum_{k=1}^{K-1}\exp(w_k\cdot x)}"/>
- 最大熵模型：
	- <img src="http://latex.codecogs.com/gif.latex?H(P)=-\sum_{x,y}\widetilde P(x)P(y|x)\log P(y|x)"/>
	- 目标是得到使H(P)最大的时候对应的P(y|x)
	- 最优化问题，最大熵模型的极大似然估计就等价于对偶函数的极大化：
	<br><img src="http://latex.codecogs.com/gif.latex?L(P,w)=-H(P)+w_0(1-\sum_yP(y|x))+\sum_{i=1}^nw_i(E_{\widetilde P}(f_i)-E_P(f_i))"/>
	<img src="http://latex.codecogs.com/gif.latex?=\sum_{x,y}\widetilde P(x)P(y|x)logP(y|x)+w_0(1-\sum_yP(y|x))"/>
	<br><img src="http://latex.codecogs.com/gif.latex?+\sum_{i=1}^nw_i(\sum_{x,y}\widetilde P(x,y)}f_i(x,y)-\sum_{x,y}\widetilde P(x)P(y|x)f_i(x,y))"/>
	<br><img src="http://latex.codecogs.com/gif.latex?\max_w \min_{P\in C}L(P,w)"/>
	- 一般形式：
	<br><img src="http://latex.codecogs.com/gif.latex?P_w(y|x)=\frac{1}{Z_w(x)}\exp(\sum_{i=1}^nw_if_i(x,y))"/>
	<br><img src="http://latex.codecogs.com/gif.latex?Z_w(x)=\sum_y\exp(\sum_{i=1}^nw_if_i(x,y))"/>
- 对数线性模型：逻辑斯蒂回归、最大熵模型，都是对模型进行极大似然估计
	- 区别？最大熵可以选择其他特征函数，logistics模型则加上了不同特征的独立性假设。
	- 梯度下降法：略
	- 迭代尺度法IIS：参数向量迭代更新，每次只优化其中一个变量
	- 拟牛顿法BFGS：改善牛顿法每次需要求解复杂的Hessian矩阵的逆矩阵的缺陷，它使用正定矩阵来近似Hessian矩阵的逆，从而简化了运算的复杂度。

## 第七章 支持向量机
- 线性可分支持向量机利用**间隔最大化**求最优分离超平面，感知机用误分类最小的策略
- 求解约束最优化
	- <img src="http://latex.codecogs.com/gif.latex?\min_{w,b}\frac12||w||^2"/>
	- <img src="http://latex.codecogs.com/gif.latex?s.t. y_i(w\cdotc x_i+b)-1\ge0,i=1,2,3...N"/>
- 对偶问题
	- <img src="http://latex.codecogs.com/gif.latex?\min_\alpha \frac12\sum_{i=1}^N\sum_{j=1}^N\alpha_i\alpha_jy_iy_j(x_i\cdot x_j)-\sum_{i=1}^N\alpha_i"/>
	- <img src="http://latex.codecogs.com/gif.latex?s.t. \sum_{i=1}^N\alpha_iy_i=0"/>
	- <img src="http://latex.codecogs.com/gif.latex?\alpha_i \ge0,i=1,2...N"/>
- 软间隔最大化：处理线性不可分情况，引入松弛变量和惩罚参数
	- 原始问题：
		- <img src="http://latex.codecogs.com/gif.latex?\min_{w,b}\frac12||w||^2+C\sum_{i=1}^N\zeta_i"/>
		- <img src="http://latex.codecogs.com/gif.latex?s.t. y_i(w\cdotc x_i+b)\ge1-\zeta_i,\zeta_i\ge 0,i=1,2,3...N"/>
	- 对偶问题：
		- <img src="http://latex.codecogs.com/gif.latex?\min_\alpha \frac12\sum_{i=1}^N\sum_{j=1}^N\alpha_i\alpha_jy_iy_j(x_i\cdot x_j)-\sum_{i=1}^N\alpha_i"/>
		- <img src="http://latex.codecogs.com/gif.latex?s.t. \sum_{i=1}^N\alpha_iy_i=0"/>
		- <img src="http://latex.codecogs.com/gif.latex?0\le\alpha_i\le C,i=1,2...N"/>
- 合页损失函数
	- SVM原始最优化问题等价于
	<img src="http://latex.codecogs.com/gif.latex?\min_{w,b}\sum_{i=1}^N[1-y_i(w\cdot x_i+b)]_++\lambda||w||^2"/>
	- 合页损失函数是0-1函数的上界，连续可导更容易优化
- 非线性支持向量机
	- 核技巧：用一个变换将原空间数据映射到新空间，然后在新空间中用线性分类学习方法
	- <img src="http://latex.codecogs.com/gif.latex?K(x,z)=\phi(x)\cdot\phi(z),\phi"/>是输入空间到特征空间的映射
	- 对偶问题的内积和分类决策函数的内积都可以用核函数替代
	- 使用核技巧之后，学习是隐式地在特征空间进行的，不需要显式地定义特征空间和映射函数
	- 正定核的充要条件：对于空降任意点，K对应的Gram矩阵是半正定的
	- 常用核函数：
		- 多项式核函数：<img src="http://latex.codecogs.com/gif.latex?K(x,z)=(x\cdotz+1)^p"/>
		- 高斯核函数：<img src="http://latex.codecogs.com/gif.latex?K(x,z)=\exp(-\frac{||x-z||^2}{2\sigma^2})"/>
		- 字符串核函数：kn(s,t)定义的是字符串s和t中长度等于n的所有子串组成的特征向量的余弦相似度
	- 算法：
		1. 选择适当的核函数K(x,z)和适当的参数C，求最优化：
		<br><img src="http://latex.codecogs.com/gif.latex?\min_\alpha \frac12\sum_{i=1}^N\sum_{j=1}^N\alpha_i\alpha_jy_iy_jK(x_i,x_j)-\sum_{i=1}^N\alpha_i"/>
		<br><img src="http://latex.codecogs.com/gif.latex?s.t. \sum_{i=1}^N\alpha_iy_i=0"/>
		<br><img src="http://latex.codecogs.com/gif.latex?0\le\alpha_i\le C,i=1,2...N"/>
		<br>求得最优解<img src="http://latex.codecogs.com/gif.latex?\alpha^*=(\alpha_1^*,\alpha_2^*...\alpha_N^*)^T"/>，当K为正定核时这个最优化问题是存在解的
		- 选择一个alpha的一个正分量，计算：
		<br><img src="http://latex.codecogs.com/gif.latex?b^*=y_i-\sum_{i=1}^N\alpha_i^*y_iK(x_i\cdot x_j)"/>
		- 构造决策函数：
		<br><img src="http://latex.codecogs.com/gif.latex?f(x)=sign(\sum_{i=1}^N\alpha_i^*y_iK(x\cdot x_x_i)+b^*)"/>
	- SMO：
		- 以上算法的第二步是一个凸二次规划问题，具有全局最优解
		- 将原二次规划问题分解为只有两个变量的二次规划自问题，并对子问题进行解析求解，知道所有变量满足KKT条件为止

## 第八章 提升方法
- 强可学习和弱可学习等价
- AdaBoost算法：
<br>输入：<img src="http://latex.codecogs.com/gif.latex?T=\{(x_1,y_1),...,(x_N,y_N)\},y=\{-1,+1\}"/>
<br>输出：最终分类器G(x)
	1. <img src="http://latex.codecogs.com/gif.latex?D_1=(w_{11},...,w_{1N}),w_{1i}=\frac1N"/>
	2. 对m=1,2...M
		1. 用带权值的D<sub>m</sub>进行学习得到分类器G<sub>m</sub>(x)
		2. 计算G<sub>m</sub>(x)在训练集上的分类误差率
		<br><img src="http://latex.codecogs.com/gif.latex?e_m=P(G_m(x_i)\ne y_i))=\sum_{i=1}^Nw_{mi}I(G_m(x_i)\ne y_i)"/>
		3. 计算G<sub>m</sub>(x)的系数
		<br><img src="http://latex.codecogs.com/gif.latex?\alpha_m=\frac12\log\frac{1-e_m}{e_m}"/>，越能分清楚的分类器加权越大
		4. 更新训练集权值分布
		<br><img src="http://latex.codecogs.com/gif.latex?D_{m+1}=(w_{m+1,1},...,w_{m+1,N})"/>
		<br><img src="http://latex.codecogs.com/gif.latex?w_{m+1,i}=\frac{w_{mi}}{Z_m}\exp(-\alpha_my_iG_m(x_i))"/>,Z<sub>m</sub>规范化因子，y<sub>i</sub>G<sub>m</sub>(x<sub>i</sub>)决定了符号，误分类样本被指数扩大
- Adaboost的训练误差是以指数速率下降的
<br>加法模型、损失函数为指数函数、学习算法为向前分步算法时的二分类学习方法
<br>向前分步算法是解决加法模型损失函数极小化的问题，adaboost是其中的特列
- 提升树：以分类树或回归树作为基本分类器的提升方法
	- 二分类问题：限定Adaboost的分类器为二分类器
	- 回归问题：加法模型，平方误差损失函数，学习方法为向前分步算法
		- 每次根据数据生成一个回归决策树（利用遍历特征和取值的平方误差最小化）
		- 然后数据更新为残差，残差=真实值-预测值
		- 提升树即为所有回归树的和
		- 循环直到平方损失误差达到要求
	- 梯度提升
		- 例如平方损失学习残差回归树，例如指数损失学习？，但是一般损失函数的优化不容易
		- GBDT
			1. 初始化，估计使损失函数极小化的常数值，它是只有一个根节点的树，即ganma是一个常数值。
			- （a）计算损失函数的负梯度在当前模型的值，将它作为残差的估计
			<br>（b）估计回归树叶节点区域，以拟合残差的近似值
			<br>（c）利用线性搜索估计叶节点区域的值，使损失函数极小化
			<br>（d）更新回归树
			- 得到输出的最终模型 f(x)

## 第九章 EM算法及其推广**(一般的极大似然概率的求解方法需要推敲)**
- 含有隐变量的概率模型参数的极大似然估计法，没有解析解只能迭代求解
	1. 初始化分布参数
	- E步：根据上一轮迭代的模型参数来计算出隐性变量的后验概率，其实就是隐性变量的期望。作为隐藏变量的现估计值
	- M步：将似然函数最大化以获得新的参数值
- EM算法是收敛的，但是不能保证收敛到全局最优
- 高斯混合模型的参数估计
- 变形-GEM算法：每次迭代增加F函数值，从而增加似然值

## 第十章 隐马尔可夫模型
- HMM：<img src="http://latex.codecogs.com/gif.latex?\lambda =(A,B,\pi)"/>，A状态转移矩阵，B观测概率矩阵，π初始状态
	- 假设：齐次马尔可夫假设、观测独立性假设
	- 概率计算问题：在λ给定的情况下，求O的概率P(O|λ)
	- 学习问题：已知O，求使得P(O|λ)最大的λ
	- 预测问题：已知λ和O，求I的概率P(I|O)
- 概率计算算法：类似动态规划
	- 前向算法（状态序列的路径结构递推）：
		- t时刻状态为q<sub>i</sub>观测为o<sub>1</sub>~o<sub>t</sub>的概率：<img src="http://latex.codecogs.com/gif.latex?\alpha_t(i)=P(o_1,...,o_t,i_t=q_i|\lambda)"/>
		- 初始：<img src="http://latex.codecogs.com/gif.latex?\alpha_1(i)=\pi_ib_i(o_1)"/>
		- 递推：<img src="http://latex.codecogs.com/gif.latex?\alpha_{t+1}(i)=[\sum_{j=1}^N\alpha_t(j)a_{ji}]b_i(o_{t+1})"/>
		- 终止：<img src="http://latex.codecogs.com/gif.latex?P(O|\lambda)=\sum_{t=1}^N\alpha_T(i)"/>
	- 后向算法：
		- t时刻状态为q<sub>i</sub>条件下，从t+1到T的观测为o<sub>t+1</sub>~o<sub>T</sub>的概率：<img src="http://latex.codecogs.com/gif.latex?\beta_t(i)=P(o_{t+1},...,o_T|i_t=q_i,\lambda)"/>
		- 初始：<img src="http://latex.codecogs.com/gif.latex?\beta_T(i)=1"/>
		- 递推：<img src="http://latex.codecogs.com/gif.latex?\beta_t(i)=\sum_{j=1}^Na_{ij}b_j(o_{t+1})\beta_{t+1}(j)"/>
		- 终止：<img src="http://latex.codecogs.com/gif.latex?P(O|\lambda)=\sum_{t=1}^N\pi_ib_i(o_1)\beta_1(i)"/>
	- 统一形式：
		<br><img src="http://latex.codecogs.com/gif.latex?P(O|\lambda)=\sum_{i=1}^N\sum_{j=1}^N\alpha_t(i)a_{ij}b_j(o_{t+1})\beta_{t+1}(j)"/>
	- 其他：
		- γ<sub>t</sub>(i)：给定λ和O，求t时处于状态q<sub>i</sub>的概率：
		<br><img src="http://latex.codecogs.com/gif.latex?\gamma_t(i)=P(i_t=q_i|O,\lambda)=\frac{P(i_t=q_i,O|\lambda)}{P(O|\lambda)}=\frac{\alpha_t(i)\beta_t(i)}{\sum_{j=1}^N\alpha_t(j)\beta_t(j)}"/>
		- ξ<sub>t</sub>(i,j)给定λ和O，求t时处于状态q<sub>i</sub>且求t+1时处于状态q<sub>j</sub>概率：
		<br><img src="http://latex.codecogs.com/gif.latex?\xi_t(i,j)=P(i_t=q_i,i_{t+1}=q_j|O,\lambda)=\frac{P(i_t=q_i,i_{t+1}=q_j,O|\lambda)}{P(O|\lambda)}=\frac{P(i_t=q_i,i_{t+1}=q_j,O|\lambda)}{\sum_{i=1}^N\sum_{j=1}^NP(i_t=q_i,i_{t+1}=q_j,O|\lambda)}"/>
		<br><img src="http://latex.codecogs.com/gif.latex?=\frac{\alpha_t(i)a_{ij}b_j(o_{t+1})\beta_{t+1}(j)}{\sum_{i=1}^N\sum_{j=1}^N\alpha_t(i)a_{ij}b_j(o_{t+1})\beta_{t+1}(j)}"/>
		- 前两者求和有用的：
			- O下状态i出现的期望：
			<br><img src="http://latex.codecogs.com/gif.latex?\sum_{t=1}^N\gamma_t(i)"/>
			- O下由状态i转移的期望：
			<br><img src="http://latex.codecogs.com/gif.latex?\sum_{t=1}^{N-1}\gamma_t(i)"/>
			- O下由状态i转移到状态j的期望：
			<br><img src="http://latex.codecogs.com/gif.latex?\sum_{t=1}^N\xi_t(i,j)"/>
- 学习算法：
	- 监督学习方法：极大似然估计，直接按照训练集中统计的频数来进行计算
	- 非监督学习方法：**Baum-Welch算法**，就是EM算法
- 预测方法：
	- 近似算法：利用γ，选择每个时刻最大概率的状态
	- 维特比算法：动态规划求概率最大的路径
		- 在时刻t时状态为i的所有单个路径(i<sub>i</sub>,...,i<sub>t</sub>)中概率最大值：
		<br><img src="http://latex.codecogs.com/gif.latex?\delta_t(i)=\max_{i_1,...,i_{t-1}}P(i_t=i,i_{t-1},...,i_1,o_t,...,o_1|\lambda)"/>
		- 递推：
		<br><img src="http://latex.codecogs.com/gif.latex?\delta_{t+1}(i)=\max_{i_1,...,i_t}P(i_{t+1},i_t,...,i_1,o_{t+1},...,o_1|\lambda)=\max_{1\le j\le N}[\delta_t(j)a_{ji}]b_i(o_{t+1})"/>
		- 记录回溯路径：在时刻t状态为i的所有单个路径(i<sub>i</sub>,...,i<sub>t-1</sub>,i)中概率最大的路径的第t-1个结点为：
		<br><img src="http://latex.codecogs.com/gif.latex?\psi_t(i)=\arg\max_{1\le j\le N}[\delta_{t-1}(j)a_{ji}]"/>

## 第十一章 条件随机场
- 马尔可夫随机场（概率无向图模型）：联合概率分布满足成对、局部或全局马尔可夫性
- 参数化形式：加权状态、转移特征
- 矩阵形式：类似HMM中的状态转移矩阵
- 概率计算
- 学习方法
- 预测

## 第十二章 总结
- k近邻也可以回归，最近k个点的算术平均算法或者考虑距离差异的加权平均
- 损失函数选择：
	- 线性回归->假设误差服从正态分布->对数似然函数->均值u和方差σ趋近于0->平方损失函数
	- 逻辑回归->假设概率分布服从伯努利分布->对数似然函数->

## 附录
- 无约束最优化
	- 梯度下降
	- 牛顿法：二阶收敛，但是求Hesse矩阵的逆，复杂度高
	- 共轭梯度法（Conjugate Gradient Method）：
	- 变尺度法：
	- 拟牛顿法：近似Hesse矩阵的逆
- 凸优化
	- 拉格朗日对偶性

## 其他算法
- 随机森林
- n-gtram算法
	- 链式规则
	<br><img src="http://latex.codecogs.com/gif.latex?P(w_1,...,w_m)=P(w_1)P(w_2|w_1)...P(w_m|w_1,w_2,...,w_{m-1})"/>
	- 利用马尔科夫链的假设，当前词仅和之前的n个词有关
	<br><img src="http://latex.codecogs.com/gif.latex?P(w_i|w_1,...,w_{i-1})=P(w_i|w_{i-n+1},..,w_{i-1})"/>
	- 算法：先从语料库求出n元模型的概率，然后语句的概率就是连乘
	- smoothing
		- Laplacian (add-one) smoothing
		- Add-k smoothing
		- Jelinek-Mercer interpolation
		- Katz backoff 
		- Absolute discounting
		- Kneser-Ney
- SVD
- 矩阵的伪逆，矩阵求导规则，
- c++ 矩阵库

## 待实现的工程
- s-fold
- 感知机 
- 梯度下降、随机梯度下降、批量梯度下降比较
- knn，kd树
- 朴素贝叶斯、贝叶斯估计
- ID3、C4.5、CART 以及他们的剪枝
- 逻辑斯蒂回归，k项推广
- 极大似然
- 拟牛顿法、迭代尺度法
- SVM、各种核、SMO
- 回归和分类提升树、GDBT
- 怎么求极大似然估计
- HMM的概率、学习、预测算法
- CRF
- PCA
- learning curve
- 训练集验证集测试集
