---
title: cs229笔记
date: 2018-12-17 00:49:12
tags:
- 笔记
- 机器学习
categories: 机器学习
---

这门课刷了两遍，这是我个人在上课期间的的一些总结，权当参考，如有错误请指正。

<!-- more -->

## Introduction
- Tom Mitchell (1998) Well-posed Learning Problem: 
>A computer program is said to learn from **experience E** with respect to some **task T** and some **performance measure P**, if its performance on T, as measured by P, improves with experience E.  

- supervised or unsupervised
- SVD：cocktail party problem algorithm

## linear Regression
- Hypothesis:
<br><img src="http://latex.codecogs.com/gif.latex?h_\theta(x)=\sum_{i=0}^n\theta_i*x_i=\theta^Tx"/>
- cost function:
<br><img src="http://latex.codecogs.com/gif.latex?J(\theta)=\frac1{2m}\sum_{i=1}^m(h_\theta(x^{(i)})-y^{(i)})^2=(X\theta-Y)^T(X\theta-Y)"/>
- Goal:
<br><img src="http://latex.codecogs.com/gif.latex?arg \min_\theta J(\theta)"/>
- Gradient descent algorithm:
<br><img src="http://latex.codecogs.com/gif.latex?\theta_i:=\theta_i-\alpha\frac{\partial}{\partial\theta_i}J(\theta)=\theta_i-\frac{\alpha}m\sum_{i=1}^m(h_\theta(x^{(i)})-y^{(i)})x_i^{(i)}"/>
<br><img src="http://latex.codecogs.com/gif.latex?\theta:=\theta-\frac{\alpha}mX^T(X\theta-Y)"/>
	- bowl-shape, never local optimal
	- batch
	- learning rate:
		- small->slow convergence
		- large->not decrease on every iteration,may not converge
- Normal equation:
<br><img src="http://latex.codecogs.com/gif.latex?J(\theta)=\frac1{2m}(X\theta-Y)^T(X\theta-Y)=\frac1{2m}(\theta^TX^T-Y^T)(X\theta-Y)"/>
<br><img src="http://latex.codecogs.com/gif.latex?=\frac1{2m}(\theta^TX^TX\theta-\theta^TX^TY-Y^TX\theta+Y^TY)"/>
<br><img src="http://latex.codecogs.com/gif.latex?\frac{\partial J(\theta)}{\partial \theta}=\frac1{2m}(2X^TX\theta-X^TY-X^TY-0)=0"/>
<br><img src="http://latex.codecogs.com/gif.latex?\therefore\theta=(X^TX)^{-1}X^TY"/>
- Gradient Descent vs Normal Equation
	- alpha
	- iterations
	- work well even n is large
- Linear Algebra:
	- Matrices are associative: (A∗B)∗C=A∗(B∗C)
	- non-invertible:singular or degenerate, use pinv 
- Feature Normalization
	- feature scaling and mean normalization
	- will oscillate inefficiently down to the optimum when the variables are very uneven
- Predictor:<img src="http://latex.codecogs.com/gif.latex?\theta^TX"/>

## Logistic Regression
- "Sigmoid Function" "Logistic Function"
<br><img src="http://latex.codecogs.com/gif.latex?h_\theta(x)=g(\theta^Tx)=\frac1{1+e^{-\theta^Tx}}=P(y=1|x;\theta)"/>
- Decision Boundary
	- 0.5
	- the line that separates the area where y = 0 and where y = 1
- Cost Function
	- We cannot use the same cost function that we use for linear regression because the Logistic Function will cause the output to be wavy, causing many local optima
<br><img src="http://latex.codecogs.com/gif.latex?cost(h_\theta(x),y)=-\log(h_\theta(x)),ify=1"/>
<br><img src="http://latex.codecogs.com/gif.latex?cost(h_\theta(x),y)=-\log(1-h_\theta(x)),ify=0"/>
<br><img src="http://latex.codecogs.com/gif.latex?cost(h_\theta(x),y)=-y\log(h_\theta(x))-(1-y)\log(1-h_\theta(x))"/>
- Gradient Descent
	- <br><img src="http://latex.codecogs.com/gif.latex?J(\theta) = - \frac{1}{m} \sum_{i=1}^m [y^{(i)}\log (h_\theta (x^{(i)})) + (1 - y^{(i)})\log (1 - h_\theta(x^{(i)}))] \newline = \frac{1}{m} \cdot (-y^{T}\log(h)-(1-y)^{T}\log(1-h))"/>
	- <br><img src="http://latex.codecogs.com/gif.latex?\theta_j := \theta_j - \frac{\alpha}{m} \sum_{i=1}^m (h_\theta(x^{(i)}) - y^{(i)}) x_j^{(i)}"/>
<br><img src="http://latex.codecogs.com/gif.latex?\theta = \theta - \frac{\alpha}{m} X^{T} (g(X \theta ) - \vec{y})"/>
- 回归问题可以推导出分类问题，用回归的线的区分性质
- optimaze
	- Conjugate gradient
	- BFGS
	- L-BFGS
	- gradient descent
- Multiclass Classification: One-vs-all
- Overfitting:
	- Reduce the number of features:
		- select which features to keep
		- model selection algorithm
	- Regularization
		- reduce the magnitude of parameters θj
		- Regularization works well when we have a lot of slightly useful features
- Regularization
	- **when j = 0，lambda=0**(不对theta0进行惩罚，所以theta0是大的,这是一个约定？？？)
		>offsets the relationship and its scale therefore is far less important to this problem. Moreover, in case a large offset is needed for whatever reason, regularizing it will prevent finding the correct relationship.
	- cost function
	<br><img src="http://latex.codecogs.com/gif.latex?min_\theta\ \dfrac{1}{2m}\ \left[ \sum_{i=1}^m (h_\theta(x^{(i)}) - y^{(i)})^2 + \lambda\ \sum_{j=1}^n \theta_j^2 \right]"/>
	- gradient descent
	<br><img src="http://latex.codecogs.com/gif.latex?\theta_j := \theta_j(1 - \alpha\frac{\lambda}{m}) - \alpha\frac{1}{m}\sum_{i=1}^m(h_\theta(x^{(i)}) - y^{(i)})x_j^{(i)}"/>
	- normal equation in linear regression
	<br><img src="http://latex.codecogs.com/gif.latex?\theta = \left( X^TX + \lambda \cdot L \right)^{-1} X^Ty"/>
		- if m ≤ n, then XTX is non-invertible. However, when we add the term λ⋅L, then XTX + λ⋅L becomes invertible.

## Neural Network
- 为什么bias总是1:只是一个偏好而已；不参与正则化:比较大的时候效果比较好
- Non-linear Hypotheses
	- feature mapping to polynomial features
	- neural network
- Represent
	<br><img src="http://latex.codecogs.com/gif.latex?a_i^{(j)}"/> = "activation" of unit i in layer j
	<br><img src="http://latex.codecogs.com/gif.latex? \Theta^{(j)}"/> = matrix of weights controlling function mapping from layer j to layer j+1
	<br><img src="http://latex.codecogs.com/gif.latex?z^{(j)} = \Theta^{(j-1)}a^{(j-1)},a^{(j)} = g(z^{(j)}),z_k^{(l)} = \sum_i\Theta_{k,i}^{(l-1)}a_i^{(l-1)}(a_0^l=\Theta_{k,0}^l=1)"/>
- Intuitions
	- XNOR
- Multiclass Classification
	- only one <img src="http://latex.codecogs.com/gif.latex?h_\Theta(x)_i=1"/>
- Cost Function
	<br><img src="http://latex.codecogs.com/gif.latex?J(\Theta) = - \frac{1}{m} \sum_{i=1}^m \sum_{k=1}^K \left[y^{(i)}_k \log ((h_\Theta (x^{(i)}))_k) + (1 - y^{(i)}_k)\log (1 - (h_\Theta(x^{(i)}))_k)\right] + \frac{\lambda}{2m}\sum_{l=1}^{L-1} \sum_{i=1}^{s_l} \sum_{j=1}^{s_{l+1}} ( \Theta_{j,i}^{(l)})^2"/>
- Backpropagation Algorithm
	<br><img src="http://latex.codecogs.com/gif.latex?\delta_j^{(l)}"/>= "error" of node j in layer l
	<br><img src="http://latex.codecogs.com/gif.latex?\delta^{(l)} = ((\Theta^{(l)})^T \delta^{(l+1)})\ .*\ g'(z^{(l)}) = ((\Theta^{(l)})^T \delta^{(l+1)})\ .*\ a^{(l)}\ .*\ (1 - a^{(l)})"/>**证明？？？**
	<br><img src="http://latex.codecogs.com/gif.latex?\dfrac{\partial J(\Theta)}{\partial \Theta_{i,j}^{(l)}} = \frac{1}{m}\sum_{t=1}^m a_j^{(t)(l)} {\delta}_i^{(t)(l+1)}"/>
![](https://i.imgur.com/4rOTo9I.png)
- Gradient Checking
	- gradient checking will assure that our backpropagation works as intended.
	<br><img src="http://latex.codecogs.com/gif.latex?\dfrac{\partial}{\partial\Theta_j}J(\Theta) \approx \dfrac{J(\Theta_1, \dots, \Theta_j + \epsilon, \dots, \Theta_n) - J(\Theta_1, \dots, \Theta_j - \epsilon, \dots, \Theta_n)}{2\epsilon}"/>
- Random Initialization
	- Initializing all theta weights to zero, all nodes will update to the same value repeatedly.
	- Initialize each Θ<sup>(l)</sup><sub>ij</sub> to a random value between[−ϵ,ϵ]:
	<br><img src="http://latex.codecogs.com/gif.latex?\epsilon = \dfrac{\sqrt{6}}{\sqrt{\mathrm{Loutput} + \mathrm{Linput}}}"/>
	<br><img src="http://latex.codecogs.com/gif.latex?\Theta^{(l)} =  2 \epsilon \; \mathrm{rand}(\mathrm{Loutput}, \mathrm{Linput} + 1) - \epsilon"/>
- Training a Neural Network
	1. Randomly initialize the weights
	2. Implement forward propagation to get hθ(x(i))
	3. Implement the cost function
	4. Implement backpropagation to compute partial derivatives
	5. Use gradient checking to confirm that your backpropagation works. Then disable gradient checking.
	6. Use gradient descent or a built-in optimization function to minimize the cost function with the weights in theta.

## Advice for Applying Machine Learning
- Errors in your predictions can be troubleshooted by:
	- Getting more training examples(fix high variance)
	- Trying smaller sets of features(fix high variance)
	- Trying additional features(fix high bias)
	- Trying polynomial features(fix high bias)
	- Increasing or decreasing λ(fix high variance/bias)
- Train/Validation/Test Sets
	- trianing set:optimize the parameters in Θ
	- validation set:find the best model with the least error
	- test set:estimate the generalization error
	- display error without lambda
- Bias vs Variance
	- underfit => bias => Jtrian high/Jcv high/Jtrain≈Jcv
	- overfit => variance => Jtrain low/Jcv high
- Learing Curves
	- high bias => more training data not help
	- high variance => more training data help
- Diagnosing Neural Networks
	- fewer parameters:underfitting,computationally cheaper
	- more parameters:overfitting,computationally expensive(increase λ to address the overfitting)
- Model Selection
	- Intuition for the bias-variance trade-off:
		- Complex model => sensitive to data => much affected by changes in X => high variance, low bias.
		- Simple model => more rigid => does not change as much with changes in X => low variance, high bias.
	- Regularization Effects:
		- Small values of λ allow model to become finely tuned to noise leading to large variance => overfitting.
		- Large values of λ pull weight parameters to zero leading to large bias => underfitting.

## Machine Learning System Design
- Error Analysis
	- Start with a simple algorithm, implement it quickly, and test it early.
	- Plot learning curves to decide if more data, more features, etc. will help
	- Error analysis: manually examine the errors on examples in the cross validation set and try to spot a trend.
- skewed classes
	- <img src="http://latex.codecogs.com/gif.latex?Precision = \frac{TP}{TP+FP}"/>
	- <img src="http://latex.codecogs.com/gif.latex?Recall = \frac{TP}{TP+FN}"/>
	- <img src="http://latex.codecogs.com/gif.latex?Accuracy = \frac{TP+TN}{TP+FP+TN+FN}"/>
	- trade-off
		- confident prediction(threshold) in logistic regression
		- <img src="http://latex.codecogs.com/gif.latex?F\_score = \frac{2PR}{P+R}"/>
## Support Vector Machine
- Optimization Objective：hinge loss
	<img src="http://latex.codecogs.com/gif.latex?J(\theta) = C\sum_{i=1}^m y^{(i)} \ \text{cost}_1(\theta^Tx^{(i)}) + (1 - y^{(i)}) \ \text{cost}_0(\theta^Tx^{(i)}) + \dfrac{1}{2}\sum_{j=1}^n \Theta^2_j"/>
-  projection：<img src="http://latex.codecogs.com/gif.latex?\Theta^Tx^{(i)} = p^{(i)} \cdot ||\Theta ||"/>
	-  the vector for Θ is perpendicular to the decision boundary. In order for our optimization objective (above) to hold true, we need the absolute value of our projections p(i) to be as large as possible.
- Kernels：allow us to make complex, non-linear classifiers using Support Vector Machines.
	-  Gaussian Kernel：<img src="http://latex.codecogs.com/gif.latex?f_i = similarity(x, l^{(i)}) = \exp(-\dfrac{||x - l^{(i)}||^2}{2\sigma^2})"/>
- Logistic Regression vs. SVMs
	- If n is large (relative to m), then use logistic regression, or SVM without a kernel (the "linear kernel")
	- If n is small and m is intermediate, then use SVM with a Gaussian Kernel
	- If n is small and m is large, then manually create/add more features, then use logistic regression or SVM without a kernel.

## Unsupervised
### Clustering
- K-means
	- 'Cluster Assignment' step
	<br><img src="http://latex.codecogs.com/gif.latex?c^{(i)} = argmin_k\ ||x^{(i)} - \mu_k||^2"/>
	- 'Move Centroid' step 
	<br><img src="http://latex.codecogs.com/gif.latex?\mu_k = \dfrac{1}{n}[x^{(k_1)} + x^{(k_2)} + \dots + x^{(k_n)}] \in \mathbb{R}^n"/>
	- always descent
	- random initialization
		- can get stuck in local optima
		- run the algorithm on many different random initializations
	- choosing K
		- the elbow method

### Dimensionality Reduction
- Motivation
	- data compression：
		- Reduce space of data
		- Speed up algorithm
	- visualization：3、2-D
- PCA（Principal Component Analysis）
	- minimizing the shortest distance，not linear regression
	- preprocess
	<br><img src="http://latex.codecogs.com/gif.latex?x_j^{(i)} = \dfrac{x_j^{(i)} - \mu_j}{s_j}"/>
	- algorithm:
		1. covariance matrix：
		<br><img src="http://latex.codecogs.com/gif.latex?\Sigma = \dfrac{1}{m}\sum^m_{i=1}(x^{(i)})(x^{(i)})^T"/>
		2. eigenvectors
		<br><img src="http://latex.codecogs.com/gif.latex?[U,S,V] = svd(sigma),U:n*n"/>
		3. take the first k columns of the U matrix and compute z
		<br><img src="http://latex.codecogs.com/gif.latex?z^{(i)} = Ureduce^T \cdot x^{(i)}"/>
	- reconstruct
	<br><img src="http://latex.codecogs.com/gif.latex?x^{(i)}_{approx}=Ureduce\cdot x^{(i)}"/>
	- choose k to be the smallest value such that
	<br><img src="http://latex.codecogs.com/gif.latex?\dfrac{\dfrac{1}{m}\sum^m_{i=1}||x^{(i)} - x_{approx}^{(i)}||^2}{\dfrac{1}{m}\sum^m_{i=1}||x^{(i)}||^2} = 1- \dfrac{\sum_{i=1}^kS_{ii}}{\sum_{i=1}^nS_{ii}} \leq 0.01"/>
	- Bad use of PCA: trying to prevent overfitting.

## Anomaly Detection
- Gaussian Distribution
	<br><img src="http://latex.codecogs.com/gif.latex?x \sim \mathcal{N}(\mu, \sigma^2)"/>
	<br><img src="http://latex.codecogs.com/gif.latex?\large p(x;\mu,\sigma^2) = \dfrac{1}{\sigma\sqrt{(2\pi)}}e^{-\dfrac{1}{2}(\dfrac{x - \mu}{\sigma})^2}"/>
	- base on independence assumption
	<br><img src="http://latex.codecogs.com/gif.latex?p(x) = p(x_1;\mu_1,\sigma_1^2)p(x_2;\mu_2,\sigma^2_2)\cdots p(x_n;\mu_n,\sigma^2_n)= \displaystyle \prod^n_{j=1} p(x_j;\mu_j,\sigma_j^2)"/>
- Anomaly if p(x)<ϵ
	- use the cross-validation set to choose parameter ϵ
- Anomaly Detection vs. Supervised Learning
	- a very small number of positive examples
	- many different "types" of anomalies
- fearture transforms
	- be gaussian
	- log(x)、x^1/2
- Multivariate Gaussian Distribution
	<br><img src="http://latex.codecogs.com/gif.latex?p(x;\mu,\Sigma) = \dfrac{1}{(2\pi)^{n/2} |\Sigma|^{1/2}} exp(-1/2(x-\mu)^T\Sigma^{-1}(x-\mu))"/>
	- automatically capture correlations between different features of x
	- original model advantages: computationally cheaper, it performs well even with small training set size
 
## Recommender Systems
- Content Based Recommendations
	<br><img src="http://latex.codecogs.com/gif.latex?min_{\theta^{(1)},\dots,\theta^{(n_u)}} = \dfrac{1}{2}\displaystyle \sum_{j=1}^{n_u}  \sum_{i:r(i,j)=1} ((\theta^{(j)})^T(x^{(i)}) - y^{(i,j)})^2 + \dfrac{\lambda}{2} \sum_{j=1}^{n_u} \sum_{k=1}^n(\theta_k^{(j)})^2"/>
	<br>θ(j)= parameter vector for user j
	<br>x(i)= feature vector for movie i
	<br>learn θ(j)
- Collaborative Filtering
	<br><img src="http://latex.codecogs.com/gif.latex?min_{x^{(1)},\dots,x^{(n_m)}} \dfrac{1}{2} \displaystyle \sum_{i=1}^{n_m}  \sum_{j:r(i,j)=1} ((\theta^{(j)})^T x^{(i)} - y^{(i,j)})^2 + \dfrac{\lambda}{2}\sum_{i=1}^{n_m} \sum_{k=1}^{n} (x_k^{(i)})^2"/>
- Collaborative Filtering Algorithm
	<br><img src="http://latex.codecogs.com/gif.latex?J(x,\theta) = \dfrac{1}{2} \displaystyle \sum_{(i,j):r(i,j)=1}((\theta^{(j)})^Tx^{(i)} - y^{(i,j)})^2 + \dfrac{\lambda}{2}\sum_{i=1}^{n_m} \sum_{k=1}^{n} (x_k^{(i)})^2 + \dfrac{\lambda}{2}\sum_{j=1}^{n_u} \sum_{k=1}^{n} (\theta_k^{(j)})^2"/>
	1. Initialize x(i),...,x(nm),θ(1),...,θ(nu) to small random values
		- break symmetry: different from each other
	2. Minimize J(x(i),...,x(nm),θ(1),...,θ(nu)) using gradient descent
		<br><img src="http://latex.codecogs.com/gif.latex?x_k^{(i)} := x_k^{(i)} - \alpha\left (\displaystyle \sum_{j:r(i,j)=1}{((\theta^{(j)})^T x^{(i)} - y^{(i,j)}) \theta_k^{(j)}} + \lambda x_k^{(i)} \right)"/>
 		<br><img src="http://latex.codecogs.com/gif.latex?\theta_k^{(j)} := \theta_k^{(j)} - \alpha\left (\displaystyle \sum_{i:r(i,j)=1}{((\theta^{(j)})^T x^{(i)} - y^{(i,j)}) x_k^{(i)}} + \lambda \theta_k^{(j)} \right)"/>
	3. For a user with parameters θ and a movie with (learned) features x, predict a star rating of θTx.
		- calculate y
	4. Implementation Detail
		- normalizing the data relative to the mean
		<br><img src="http://latex.codecogs.com/gif.latex?(\theta^{(j)})^T x^{(i)} + \mu_i"/>

## Week 10 Lecture Notes
- Stochastic Gradient Descent 
	<br><img src="http://latex.codecogs.com/gif.latex?\alpha = \dfrac{const1}{iterationNumber + const2}"/>
- Mini-Batch Gradient Descent
- Online Learning
	- continuously updating theta with a continuous stream
- Map Reduce and Data Parallelism

## 一些证明题
- Normal eauation partial in linear Regression
- Gradient Descent in Logistic Regression
- BP in Neural Network
- 不需要feature scaling的机器学习算法：没有用到梯度下降的

## cs229补充
- 非参数机器学习算法
	- 对于目标函数形式不作过多的假设的算法称为非参数机器学习算法。通过不做假设，算法可以自由的从训练数据中学习任意形式的函数。
	- 当你拥有许多数据而先验知识很少时，非参数学习通常很有用，此时你不需要关注于参数的选取。
	- 一些非参数机器学习算法的例子包括：
		- 决策树，例如CART和C4.5
		- 朴素贝叶斯
		- 支持向量机
		- 神经网络
	- 非参数机器学习算法的优势：
		- 可变性：可以拟合许多不同的函数形式。
		- 模型强大：对于目标函数不作假设或者作微小的假设
		- 表现良好：对于预测表现可以非常好。
	- 非参数机器学习算法局限性：
		- 需要更多数据：对于拟合目标函数需要更多的训练数据
		- 速度慢：因为需要训练更多的参数，训练过程通常比较慢。
	- 过拟合：有更高的风险发生过拟合，对于预测也比较难以解释。
- 感知学习算法
- 指数族
	- softmax回归
- GDA
- event model for textclassifier
- ablative analysis
- feature select
	- wrapper methods
		- forward search
		- backward search
	- filter methos
		- mutual information
		- KL divergence
- 降维算法总结：
	- linear
		- PCA
			- 新生成的点之间方差仍然最大
			- 协方差矩阵做SVD分解，取特征值最大的保留
		- FA
			- 低维样本点经过高斯分布、线性变换、误差扰动生成
			- 用EM算法解决
		- ICA
			- 
	- nonlinear
		- local
			- LLE
			- laplacian EMs
		- global
			- kernel PCA
			- Auto-encoder
			- SOM
			- MDS
- Ensemble Method：得到若干个体学习器，选择结合策略
	- 个体学习器可以同质异质，强依赖（串行boosting）弱依赖（并行boosting）
	- 结合策略：平均法（回归）、投票法（分类）、学习法（stacking）
	- boosting：基于错误提升分类器性能，通过集中关注被已有分类器分类错误的样本，构建新分类器并集成。
		- 误差率e，学习器权重alpha，样本权重D，结合策略
		- adaboost: boosting + 单层cart决策树or神经网络
			- 训练出G，e为加权错误率
			- α=1/2*log（（1−e）/e）
			- w<sub>i</sub>:=w<sub>i</sub>/Z*exp(−αy<sub>i</sub>G(x<sub>i</sub>))
			- f(x)=sign(∑α<sub>k</sub>G<sub>k</sub>(x))
		- adaboost多分类：
			- M1：要求弱分类器大于1/2
			- M2：伪损失，置信度
			- HM：把每个样本的分类，转化为k个10标签
			- SAMME：弱分类器大于1/k
		- 优缺点：不容易发生过拟合，对异常样本敏感
		- boosting tree：向前分步算法，每次拟合残差学习一个回归树
		- GBDT：残差即负梯度
		- XGBoost：二阶信息
	- bagging：基于数据随机重抽样，分类投票，回归平均
		- random forest：bagging + CART
			- NxM训练集bootstrap sampleN样本，**选m个featrue**
			- 生成决策树不剪枝
			- 回归：森林求平均；分类：森林投票
			- m提高，树的相关度提高，错误率提高；树的分类能力提高，错误率降低
			- oob误分率：选择没有拿某样本进行训练的树们对该样本进行预测。计算总的误分类率
		- rf推广
			- extra trees：
				- 使用原始数据不抽样，随机选特征值来划分决策树
				- 决策树更大，泛化能力更好
			- Totally Random Trees Embedding：特征转换
				- 建立T个决策树来拟合数据
				- 每一个样本，都可以被表示为它在每一棵树上的叶子的索引
				- 生成的高维特征可以用于各种分类回归算法
			- Isolation Forest：异常点检测
				- 采样远小于训练集
				- 决策树随机划分，设置比较小的决策树最大深度
		- rf优缺点：
			- 并行、特征维度高的时候高效，部分特征缺失不敏感、生成特征重要度（每个特征加噪声，加噪声后的oob2-oob的平均）
			- 噪声大容易过拟合
	- stacking：将训练好的所有基模型对整个训练集进行预测，第j个基模型对第i个训练样本的预测值将作为新的训练集中第i个样本的第j个特征值，最后基于新的训练集进行训练。