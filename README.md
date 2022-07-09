[Google Colab](https://colab.research.google.com/notebooks/welcome.ipynb?hl=ko)

I am hungry for battle?
---
<b>data</b>
- 공공 데이터
  - [공공데이터포털](https://data.go.kr)
  - [통계청 MDIS](https://mdis.kostat.go.kr/index.do)
  - [서울시 열린데이터광장](https://data.seoul.go.kr/) : 지하철 이용 데이터, 미세먼지 데이터 등
- 민간 데이터 : 일부 기업이 제한적인 내부 데이터 공개
  - [SKT 빅데이터허브](https://bigdatahub.co.kr) : 지역/시간대/업종별 통화량 데이터 등
  - [네이버 데이터랩](https://datalab.naver.com) : 검색어 통계 및 지역/업종/연령/성별 카드 사용 통계 (BC카드)
- US data Websites
  - censusreporter.org : visualized data
  - data.census.gov : customized tables
  - [SuperDataScience](https://www.superdatascience.com/machine-learning) : Machine Learning A-Z Download Practice Datasets

<b>[kaggle](kaggle.com)</b>
- 2010년 설립된 예측 모델 및 분석 대회 플랫폼
- 다양한 기업의 실제 데이터와 분석 사례있음
- 기업/단체는 문제를 해결하고 데이터 사이언티스트는 실력을 확인할 수 있는 기회 제공

<b>community</b>
- [Data Science Central](https://www.datasciencecentral.com/) : A community for Big Data Practitioners

<b>resources</b>
- [Top Research Papers in Data Science [2020] Free download](https://roboticsbiz.com/top-research-papers-in-data-science-2020-free-download)
- [딥린이를 위한 필독 논문 리스트](https://hsuuu.tistory.com/m/4)
- [TechProFree](https://www.techprofree.com/) : Programming Books, Projects, Python
- [Genial Code](https://genial-code.com/) : Python project examples and programming books
- [StatQuest with Josh Starmer](https://www.youtube.com/user/joshstarmer/videos)
  - StatQuest is sponsored by JAD (Just Add Data)
- [Explained Visually](https://setosa.io/ev/) : Concepts Visually Explained

---
<b>deep learning framework</b>
- TensorFlow: 다양한 플랫폼으로 확장 중
  - [tensorflow hub](https://www.tensorflow.org/hub?hl=ko) : ML엔지니어들이 finetuning 할 수 있는 model, weight, layer 공유
  - tensorboard
- Pytorch : 진입 장벽이 낮고 속도가 빠름
- Caffe2 : from Facebook
  - [PyTorch vs Caffe2](https://analyticsindiamag.com/pytorch-vs-caffe2-which-machine-learning-framework-should-you-use-for-your-next-project/)
    - Application: It is mainly meant for the purpose of production
      - applications involving large-scale image classification and object detection
    - Model deployment : run on any platform once coded (more developer-friendly)
    - Flexible: PyTorch is much more flexible
- MarConvNet : MATLAB 환경에 익숙한 연구원들에게 좋음
---
<b>Data Science library</b>
- Numpy, SciPy : for analysis
- Matplotlib : for data visualization
- TensorFlow : for Machine Learning
- tqdm
  - 진행상황을 표시하는 바
  - 반복문에서 사용하면 어느정도로 진행했는지 알 수 있어서 좋음
- re
  - 분석을 위해 문자열 리스트 정형화
  - 공백문자 제거, 필요 없는 문장 부호 제거, 대소문자 맞추기 : `re.sub('[!#?]','',value)`
  - `문자열.strip()` : 문자열에서 양쪽 끝에 있는 공백과 \n 기호를 삭제, 중간에 존재하는 것은 제거 X
  - `문자열.title()` : 첫 글자 대문자

---
<b>NLP</b>
- [KoNLPy](https://cceeddcc.tistory.com/8) : 한국어 정보처리를 위한 파이썬 패키지
- [LSTM](https://bangseogs.tistory.com/96)

---
<b>[wandB](https://wandb.ai/site)</b>
- tensorboard와 비슷한데 훨씬 더 많은 기능 제공
  - tensorflow, pytorch 등 사용하면서 어떤 걸로 logging 하면 좋을지 모르겠을 때
  - cloud 기반으로 집과 오피스 등 여러 곳에서 수시로 확인하고 싶을 때
  - hardware 에러 체크하고 싶을 때 (GPU 쓰다 보면 처음 보는 에러 발생해서 죽는 경우 있는데 그때 보통 hardware 에러)
- basic (free)
- experiments - try a live colab : research용 tool
- DOCS : 설명 잘 되어 있음

<b>[Hydra](https://hydra.cc/docs/intro/)</b>
- 여러 hyperparameter configuration 관리하기 위한 open source tool
- configuration을 여러 개의 파일(.py)로 쪼갰을 때 효율적
- tool이 OmegaConf와 거의 비슷
  - OmegaConf를 관리하던 개발자가 facebook에 casting 되어 만듦
  - https://omegaconf.readthedocs.io/en/2.1_branch/
  - DictConfig : Dictionary 형태의 configuration

<b>[Pytorch Lightning](https://www.pytorchlightning.ai/)</b>
- pytorch를 효율적으로 활용하기 위함
- pytorch lightning 쓰면 코드가 깔끔하고 작업 시간도 감소
  - GPU를 두 개 이상 사용하거나, 모델을 분산처리 하는 등을 하려면 pytorch는 tensorflow 대비 코딩이 어려워지기 때문
  - i.e. multi GPU training 할 때 pytorch에서는 몇 번 GPU 썼는지 `CUDA`를 코드에 써야 하는데 그런 작업 필요 없음

---
<b>cloud platform</b>
- aws : 초기 클라우드 시장 점령
- Google CloudPlatform : 공개적 마케팅 중
- Microsoft Azure : B2B 중심으로 자리잡음

---
<b>Memo</b>
- [Mathematics in Markdown](https://rpruim.github.io/s341/S19/from-class/MathinRmd.html)
- Modeling : ① Neural Network : overfitting -> ② SVM : learning time too long -> ③ Ensemble ex) bagging(rf), boosting, NN + RF

