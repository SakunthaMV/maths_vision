Map<String, dynamic> goldenMap = {
  'Alpha':{
    'part1':{
      'question': {
        'firstLine': r'\mathbf{\cos^6 \bm\theta + \sin^6 \bm\theta}',
        'thirdLine': 'මෙම ප්‍රකාශය සමාන වනුයේ පහත ප්‍රකාශ අතුරින් කුමකටද?',
      },
      'answers': [
        r'3 - \sin^2 \theta \cos^2 \theta',
        r'3 + \sin \theta \cos \theta',
        r'1 + 3 \sin^2 \theta \cos^2 \theta',
        r'1 - 3 \sin^2 \theta \cos^2 \theta',
        r'3 + \sin^2 \theta \cos^2 \theta',
      ],
      'answer': r'1 - 3 \sin^2 \theta \cos^2 \theta',
    },
    'part2':{
      'question': {
        'firstLine': r'\mathbf{1 - 3 \sin^2 \theta \cos^2 \theta}',
        'thirdLine': 'මෙම ප්‍රකාශය සමාන වනුයේ පහතින් කුමන ප්‍රකාශයටද?',
      },
      'answers': [
        r'\frac 3 4 \cos 4\theta + \frac 5 4',
        r'\frac 3 4 \sin 4\theta + \frac 5 4',
        r'\frac 3 8 \cos 4\theta - \frac 5 8',
        r'\frac 3 8 \cos 4\theta + \frac 5 8',
        r'\frac 3 8 \sin 4\theta + \frac 5 4',
      ],
      'answer': r'\frac 3 8 \cos 4\theta + \frac 5 8',
    },
    'part3':{
      'question': {
        'firstLine': r'\mathbf{\cos^6 \bm\theta + \sin^6 \bm\theta = \frac 1 2 \sin 4 \bm\theta + \frac 5 4 }',
        'secondLine': [
          'නම්',
          r'\mathbf{\theta}',
          'හි',
        ],
        'thirdLine': ' සාධාරන විසඳුම සොයන්න.',
      },
      'answers': [
        r'\theta = \frac {n\pi} 2 - \frac 1 4 \cos^{-1} \Big(\frac 3 5 \Big)',
        r'\theta = \frac {n\pi} 2 \pm \frac 1 4 \cos^{-1} \Big(\frac 3 5 \Big)',
        r'\theta = {n\pi} + \frac 1 2 \cos^{-1} \Big(\frac 3 5 \Big)',
        r'\theta = {n\pi} + \frac 1 4 \cos^{-1} \Big(\frac 3 5 \Big)',
        r'\theta = {n\pi} \pm \frac 1 4 \cos^{-1} \Big(\frac 3 5 \Big)',
      ],
      'answer': r'\theta = \frac {n\pi} 2 - \frac 1 4 \cos^{-1} \Big(\frac 3 5 \Big)',
    }
  },
  'Beta':{
    'part1':{
      'question': {
        'firstLine': r'\mathbf{\frac {\tan \bm\theta + \sec \bm\theta - 1} {\tan \bm\theta - \sec \bm\theta + 1}}',
        'thirdLine': 'මෙම ප්‍රකාශය සමාන වනුයේ පහත ප්‍රකාශ අතුරින් කුමකටද?',
      },
      'answers': [
        r'\cosec \theta + \cot \theta',
        r'\cosec \theta + \tan \theta',
        r'\sec \theta + \tan \theta',
        r'\sec \theta + \cot \theta',
        r'\cosec \theta - \tan \theta',
      ],
      'answer': r'\sec \theta + \tan \theta',
    },
    'part2':{
      'question': {
        'firstLine': r'\mathbf{\sec \theta + \tan \theta = \frac a b}',
        'secondLine': [
          'නම්',
          r'\mathbf{\cos \theta}',
          'හි',
        ],
        'thirdLine': 'අගය සමාන වනුයේ පහතින් කුමන ප්‍රකාශයටද?',
      },
      'answers': [
        r'\frac {a + b} {a^2 + b^2}',
        r'\frac {2ab} {a^2 + b^2}',
        r'\frac {2ab} {a + b}',
        r'\frac {a + b} {a - b}',
        r'\frac {ab} {a + b}',
      ],
      'answer': r'\frac {2ab} {a^2 + b^2}',
    },
    'part3':{
      'question': {
        'firstLine': r'\mathbf{\cos^{-1} \Big(\frac {2ab} {a^2 + b^2} \Big) + \bm\alpha = \frac \pi 4}',
        'secondLine': [
          'නම්',
          r'\mathbf{\alpha}',
          '',
        ],
        'thirdLine': 'සොයන්න. ',
        'forthLine': r'(a>b)'
      },
      'answers': [
        r'\alpha = \tan^{-1} \frac {(a+b)^2} {(a-b)^2}',
        r'\alpha = \tan^{-1} \Big ( \frac {b^2 + 2ab - a^2} {a^2 + b^2} \Big)',
        r'\alpha = \tan^{-1} \Big( \frac {a^2 + b^2} {b^2 + 2ab - a^2} \Big)',
        r'\alpha = \tan^{-1} \frac {a^2 + b^2} {(a-b)^2}',
        r'\alpha = \tan^{-1} \Big( \frac {b^2 + 2ab - a^2} {a^2 + 2ab - b^2} \Big)',
      ],
      'answer': r'\alpha = \tan^{-1} \Big( \frac {b^2 + 2ab - a^2} {a^2 + 2ab - b^2} \Big)',
    }
  },
  'Gamma':{
    'part1':{
      'question': {
        'firstLine': r'\mathbf{\tan^{-1} \frac 1 7 + 2 \tan^{-1} \frac 1 3}',
        'thirdLine': 'මෙම ප්‍රකාශය පහත කුමන කෝණයකට සමාන වේද?',
      },
      'answers': [
        r'\tan^{-1} \Big( \frac {10} {21} \Big)',
        r'\tan^{-1} \Big( \frac {17} {21} \Big)',
        r'\tan^{-1} \Big( \frac {3} {4} \Big)',
        r'\frac {\pi} {4}',
        r'\tan^{-1} \Big( \frac {1} {2} \Big)',
      ],
      'answer': r'\frac {\pi} {4}',
    },
    'part2':{
      'question': {
        'firstLine': r'\mathbf{\sin \bm\theta + \sin 3 \bm\theta = \sin 2 \bm\theta}',
        'secondLine': [
          'නම්',
          r'\mathbf{\theta}',
          'හි',
        ],
        'thirdLine': 'සාධාරන විසඳුම් තෝරන්න.',
      },
      'answers': [
        r'\theta = \frac {n \pi} {2} + (-1)^n \pi \text{  }\bm{or}\text{  } \theta = 2n \pi \pm \frac {\pi} {6}',
        r'\theta = \frac {n \pi} {2} \text{  }\bm{or}\text{  } \theta = 2n \pi ',
        r'\theta = \frac {n \pi} {2}  \text{  }\bm{or}\text{  } \theta = 2n \pi \pm \frac {\pi} {6}',
        r'\theta = \frac {n \pi} {2} + (-1)^n \pi \text{  }\bm{or}\text{  } \theta = 2n \pi \pm \frac {\pi} {3}',
        r'\theta = \frac {n \pi} {2} \text{  }\bm{or}\text{  } \theta = 2n \pi \pm \frac {\pi} {3}',
      ],
      'answer': r'\theta = \frac {n \pi} {2} \text{  }\bm{or}\text{  } \theta = 2n \pi \pm \frac {\pi} {3}',
    },
    'part3':{
      'question': {
        'firstLine': r'\mathbf{A= \sin^{-1} \Big(\frac 1 {\sqrt{10}} \Big)}',
        'secondLine': [
          'නම්',
          r'\mathbf{3 \sin 2 \bm\theta + 2 \sin^2 \bm\theta = 2}',
          'සමීකරණයේ',
        ],
        'thirdLine': 'පහත පරාසය තුළ ඇති A ගෙන් ස්වායත්ත විසඳුම සොයන්න. ',
        'forthLine': r'(\pi < \bm\theta <2\pi)'
      },
      'answers': [
        r'\theta = \frac {\pi} 2',
        r'\theta = \frac {\pi} 2 + \sin^{-1} \Big( \frac 1 {\sqrt{10}} \Big)',
        r'\theta = \frac {3 \pi} 2',
        r'\theta = \frac {7 \pi} 2',
        r'\theta = \frac {7 \pi} 6 + \sin^{-1} \Big( \frac 1 {\sqrt{10}} \Big)',
      ],
      'answer': r'\theta = \frac {3 \pi} 2',
    }
  },
  'Delta':{
    'part1':{
      'question': {
        'firstLine': r'\mathbf{(b^2 - c^2) \cot A + (c^2 - a^2) \cot B + (a^2 - b^2) \cot C}',
        'thirdLine': 'සාධාරන ත්‍රිකෝණයක සම්මත අංකනයට අනුව මෙම ප්‍රකාශය සමාන වනුයේ පහත කුමන ප්‍රකාශයටද?',
      },
      'answers': [
        r'0',
        r'\frac {a^2 + b^2 + c^2} abc',
        r'\frac {abc} {a^2 + b^2 + c^2}',
        r'3',
        r'\frac {3abc} {a^2 + b^2 + c^2}',
      ],
      'answer': r'0',
    },
    'part2':{
      'question': {
        'firstLine': r'a^2 + c^2 = 2 b^2',
        'secondLine': [
          'නම් ',
          r'\mathbf{\cot A + \cot C}',
          'යන ප්‍රකාශය ',
        ],
        'thirdLine': 'සාධාරන ත්‍රිකෝණයක සම්මත අංකනයට අනුව කුමන ප්‍රකාශයකට සමාන වේද?',
      },
      'answers': [
        r'\cot B',
        r'2 \cot \frac B 2',
        r'2 \cot B',
        r'\cot \frac B 2',
        r'\frac 1 2 \cot B',
      ],
      'answer': r'2 \cot B',
    },
    'part3':{
      'question': {
        'firstLine': r'\mathbf{\sqrt{6} \cos (\theta - \bm\alpha) - \tan\theta = \sqrt{2}}',
        'secondLine': [
          'නම්',
          r'x',
          'හී සාධාරන විසඳුම් සොයන්න.',
        ],
        'thirdLine': 'මෙහි,',
        'forthLine': r'\sin \bm\alpha =\frac 1 {\sqrt{3}} , \text{  }\cos \bm\alpha =\frac {\sqrt{2}} {\sqrt{3}}'
      },
      'answers': [
        r'\theta = n \pi \pm \frac {\pi} 2 + \alpha \text{  }\bm {or}\text{  } \theta = 2n \pi \pm \frac {\pi} 2',
        r'\theta = n \pi \pm \frac {\pi} 2 \text{  }\bm {or}\text{  } \theta = 2n \pi \pm \frac {\pi} 4 + \alpha ',
        r'\theta = 2n \pi \pm \frac {\pi} 2 + \alpha \text{  }\bm {or}\text{  } \theta = 2n \pi \pm \frac {\pi} 4',
        r'\theta = n \pi \pm \frac {\pi} 4 + \alpha \text{  }\bm {or}\text{  } \theta = 2n \pi \pm \frac {\pi} 4',
        r'\theta = 2n \pi \pm \alpha \text{  }\bm {or}\text{  } \theta = 2n \pi \pm \frac {\pi} 2',
      ],
      'answer': r'\theta = 2n \pi \pm \frac {\pi} 2 + \alpha \text{  }\bm {or}\text{  } \theta = 2n \pi \pm \frac {\pi} 4',
    }
  },
  'Epsilon':{
    'part1':{
      'question': {
        'firstLine': r'\mathbf{\bm\alpha - \bm\beta =\sin^{-1} \frac {x(1+x)} {1+x^2} }',
        'secondLine': [
          'මෙහි',
          r'\mathbf{\bm\alpha = \sin^{-1} \frac 1 {\sqrt{1+x^2}} , \text{  } \bm\beta = \sin^{-1} \frac x {\sqrt{1+x^2}}} ',
          '',
        ],
        'thirdLine': 'ද වේ නම්, මෙහි x හී අගය සොයන්න.',
        'forthLine':r'\Big(\bm\alpha , \bm\beta < \frac {\pi} 2 \Big)',
      },
      'answers': [
        r'0',
        r'\frac 1 2',
        r'1',
        r'-1',
        r'\frac {-1} 2',
      ],
      'answer': r'\frac 1 2',
    },
    'part2':{
      'question': {
        'firstLine': r'\mathbf{\cot\theta = \frac {\sin 2 \bm\theta} {1-3 \cos 2 \bm\theta}}',
        'secondLine': [
          'නම්',
          r'\mathbf{\bm\theta}',
          'හි',
        ],
        'thirdLine': 'සාධාරන විසඳුම් තෝරන්න.',
      },
      'answers': [
        r'\theta = 2n \pi \pm \frac {\pi} {2} \text{  }\bm{or}\text{  } \theta = n \pi \pm \frac {\pi} {4}',
        r'\theta = 2n \pi \pm \frac {\pi} {2}',
        r'\theta = 2n \pi \pm \frac {\pi} {4} \text{  }\bm{or}\text{  } \theta = 2n \pi \pm \frac {\pi} {2}',
        r'\theta = n \pi \pm \frac {\pi} {4} \text{  }\bm{or}\text{  } \theta = n \pi \pm \frac {\pi} {2}',
        r'\theta = n \pi \pm \frac {\pi} {2}',
      ],
      'answer': r'\theta = 2n \pi \pm \frac {\pi} {2} \text{  }\bm{or}\text{  } \theta = n \pi \pm \frac {\pi} {4}',
    },
    'part3':{
      'question': {
        'firstLine': r'\mathbf{\cot \bm\theta - (7+4 \sqrt{3}) \cot (\bm\theta + \bm\alpha)=0}',
        'thirdLine': 'නම් පහත කුමන ප්‍රකාශය සත්‍යවේද.',
      },
      'answers': [
        r'\sin (2 \theta + \alpha) = \sqrt{3} \sin \alpha',
        r'\sin (\theta + \alpha) = 2 \sin \alpha',
        r'\sqrt{3} \sin (2 \theta + \alpha) = \sin \alpha',
        r'\sin ( \theta - \alpha) =\frac 1 2 \sin \alpha',
        r'\sqrt{3} \sin (2 \theta + \alpha) = 2 \sin \alpha',
      ],
      'answer': r'\sqrt{3} \sin (2 \theta + \alpha) = 2 \sin \alpha',
    }
  },
  'Lambda':{
    'part1':{
      'question': {
        'firstLine': r'\mathbf{\sin \bm\theta + \sin \bm\phi = a ,\text{ } \cos \bm\theta + \cos \bm\phi = b}',
        'secondLine': [
          'නම්',
          r'\mathbf{\sin (\bm\theta + \bm\phi)} ',
          '',
        ],
        'thirdLine': 'සොයන්න.',
      },
      'answers': [
        r'\frac {a+b} {a^2 + b^2}',
        r'\frac {2ab} {a^2 + b^2}',
        r'\frac {2ab} {a + b}',
        r'\frac {a+b} {a - b}',
        r'\frac {ab} {a + b}',
      ],
      'answer': r'\frac {2ab} {a^2 + b^2}',
    },
    'part2':{
      'question': {
        'firstLine': r'\mathbf{\sin \bm\theta + \sin \bm\phi = a ,\text{ } \cos \bm\theta + \cos \bm\phi = b}',
        'secondLine': [
          'නම්',
          r'\mathbf{\cos (\bm\theta + \bm\phi) \text{ } \bm{and}\text{ } \cos (\bm\theta - \bm\phi)}',
          'හි',
        ],
        'thirdLine': 'හී අගයන් පිළිවලින්,',
      },
      'answers': [
        r'\frac {(b-a)^2} {a^2 + b^2} \text{ } \bm{and}\text{ } (a-b)^2',
        r'\frac {(a-b)^2} {a + b} \text{ } \bm{and}\text{ } (a^2 + b^2 - 2)',
        r'\frac {b-a} {a + b} \text{ } \bm{and}\text{ } \Big(\frac {a^2 + b^2 - 2} {2}\Big)',
        r'\frac {b^2-a^2} {a^2 + b^2} \text{ } \bm{and}\text{ } \Big(\frac {a^2 + b^2 - 2} {2}\Big)',
        r'\frac {2ab} {a^2 - b^2} \text{ } \bm{and}\text{ } (a+b)^2',
      ],
      'answer': r'\frac {b^2-a^2} {a^2 + b^2} \text{ } \bm{and}\text{ } \Big(\frac {a^2 + b^2 - 2} {2}\Big)',
    },
    'part3':{
      'question': {
        'firstLine': r'\mathbf{\sin \bm\theta + \sin \bm\phi = a ,\text{ } \cos \bm\theta + \cos \bm\phi = b}',
        'secondLine': [
          'නම්',
          r'\mathbf{\tan \bm\theta + \tan \bm\phi}',
          'හි',
        ],
        'thirdLine': 'අගය සොයන්න.',
      },
      'answers': [
        r'\frac {8ab} {a^2 + b^2 - 4a}',
        r'\frac {8ab} {(a^2 + b^2)^2}',
        r'\frac {8ab} {(a^2 + b^2)^2 - 4a^2}',
        r'\frac {4ab} {a^2 + b^2 - 2a}',
        r'\frac {4ab} {(a^2 + b^2)^2}',
      ],
      'answer': r'\frac {8ab} {(a^2 + b^2)^2 - 4a^2}',
    }
  },
  'Mu':{
    'part1':{
      'question': {
        'firstLine': r'\mathbf{\sin^{-1} x + \sin^{-1} y = \frac \pi 3}',
        'thirdLine': 'නම් පහත කුමන ප්‍රකාශය සත්‍ය වේද?',
      },
      'answers': [
        r'x^2 + y^2 + xy = \frac 3 4',
        r'(x + y)^2 = \frac 3 4',
        r'(x - y)^2 + xy = \frac {\sqrt 3} 2',
        r'x^2 + y^2 - xy = \frac {\sqrt 3} 2',
        r'x^2 - y^2 + xy = \frac 3 4',
      ],
      'answer': r'x^2 + y^2 + xy = \frac 3 4',
    },
    'part2':{
      'question': {
        'firstLine': r'\mathbf{\cos 2\bm\theta\tan\bm\theta + \sin\bm\theta = 0}',
        'thirdLine': 'හි සාදාරන විසඳුම් පහතින් තෝරන්න.',
      },
      'answers': [
        r'\theta = n\pi \text{ } \bm{or}\text{ } \theta = 2n\pi \pm \frac \pi 3',
        r'\theta = \frac {n\pi} 2 \text{ } \bm{or}\text{ } \theta = 2n\pi \pm \frac \pi 6',
        r'\theta = n\pi + \frac \pi 3 \text{ } \bm{or}\text{ } \theta = 2n\pi \pm \frac \pi 2',
        r'\theta = n\pi \text{ } \bm{or}\text{ } \theta = 2n\pi \pm \frac \pi 6',
        r'\theta = \frac {n\pi} 2 + \frac \pi 4 \text{ } \bm{or}\text{ } \theta = 2n\pi \pm \frac \pi 3',
      ],
      'answer': r'\theta = n\pi \text{ } \bm{or}\text{ } \theta = 2n\pi \pm \frac \pi 3',
    },
    'part3':{
      'question': {
        'firstLine': r'\mathbf{\frac 1 a \cos^2 \bigg(\frac A 2\bigg) + \frac 1 b \cos^2 \bigg(\frac B 2\bigg) + \frac 1 c \cos^2 \bigg(\frac C 2\bigg)}',
        'thirdLine': 'සාදාරන ත්‍රිකෝණයක සම්මත අංකනයට අනුව, ඉහත ප්‍රකාශට සමාන ප්‍රකාශය පහත ප්‍රකාශ අතුරින් තෝරන්න.',
      },
      'answers': [
        r'\frac {(a + b + c)^2} {4abc}',
        r'\frac {(a - b - c)^2} {4abc}',
        r'\frac {(a + b - c)^2} {2abc}',
        r'\frac {(a - b - c)^2} {abc}',
        r'\frac {(a + b + c)^2 - 4ab} {2abc}',
      ],
      'answer': r'\frac {(a + b + c)^2} {4abc}',
    }
  },
  'Tau':{
    'part1':{
      'question': {
        'firstLine': r'.',
        'thirdLine': 'වර්ගඵලය ඒකක p වූ වෘත්තයක පාදයක් තුල අන්තර්ගත කල වෘත්තයක වර්ගඵලය වනුයේ පහත කුමක්ද?',
      },
      'answers': [
        r'(2\sqrt 3 - 2)p',
        r'(3\sqrt 2 - 2)p',
        r'(3 - 2\sqrt 2)p',
        r'(\sqrt 2 - 1)p',
        r'(\sqrt 3 - 1)p',
      ],
      'answer': r'(3 - 2\sqrt 2)p',
    },
    'part2':{
      'question': {
        'firstLine': r'\mathbf{6\tan 2\bm\theta - 3\tan\bm\theta - 5\cot\bm\theta = 0}',
        'secondLine': [
          'නම්',
          r'\mathbf{\theta}',
          'හි',
        ],
        'thirdLine': 'සාදාරන විසඳුම් හෝ විසඳුම පහතින් තෝරන්න.',
      },
      'answers': [
        r'\theta = n\pi \pm \frac \pi 6',
        r'\theta = 2n\pi + \frac \pi 6',
        r'\theta = \frac {n\pi} 2 \pm \frac \pi 3',
        r'\theta = n\pi + \frac \pi 3 \text{ } \bm{or}\text{ } \theta = n\pi - \frac \pi 6',
        r'\theta = n\pi + \frac \pi 6 \text{ } \bm{or}\text{ } \theta = n\pi - \frac \pi 3',
      ],
      'answer': r'\theta = n\pi \pm \frac \pi 6',
    },
    'part3':{
      'question': {
        'firstLine': r'\mathbf{\cot^{-1} \bigg(\frac {xy + 1} {x - y}\bigg) + \cot^{-1} \bigg(\frac {yz + 1} {y - z}\bigg) + \cot^{-1} \bigg(\frac {zx + 1} {z - x}\bigg)}',
        'thirdLine': 'මෙම ප්‍රකාශය සුලු කිරීමෙන් ලැබෙනුයේ පහත කුමන ප්‍රකාශයද?',
      },
      'answers': [
        r'\frac \pi 4',
        r'\tan^{-1} \bigg(\frac {xy + yz + zx} {xyz}\bigg)',
        r'\tan^{-1} \bigg(\frac {xy - yz - zx} {2xyz}\bigg)',
        r'0',
        r'\tan^{-1} \bigg(\frac {3xyz} {x^2 + y^2 + z^2}\bigg)',
      ],
      'answer': r'0',
    }
  },
  'Phi':{
    'part1':{
      'question': {
        'firstLine': r'\mathbf{f(x) = \frac 1 {4\sin x - 3\cos x + 6}}',
        'thirdLine': 'මෙම ශ්‍රිතයේ වැඩිතම අගය සහ අඩුතම අගය පිලිවලින් පහතින් තෝරන්න.',
      },
      'answers': [
        r'\frac 1 6 ,\text{ } \frac 1 7',
        r'1 ,\text{ } \frac 1 {11}',
        r'\frac 1 7 ,\text{ } \frac 1 {13}',
        r'1 ,\text{ } \frac 1 {13}',
        r'\frac 1 6 ,\text{ } \frac 1 {13}',
      ],
      'answer': r'1 ,\text{ } \frac 1 {11}',
    },
    'part2':{
      'question': {
        'firstLine': r'\mathbf{\tan\bigg[\cos^{-1} x\bigg] = \sin\bigg[\cot^{-1} \Big(\frac 1 2\Big)\bigg]}',
        'secondLine': [
          'නම්',
          r'\mathbf{x}',
          'හි',
        ],
        'thirdLine': 'අගය සොයන්න.',
      },
      'answers': [
        r'\pm \frac {\sqrt 5} 3',
        r'\frac {\sqrt 5} 3',
        r'\pm \sqrt 5',
        r'\frac {\sqrt 5} 9',
        r'\sqrt 5',
      ],
      'answer': r'\frac {\sqrt 5} 3',
    },
    'part3':{
      'question': {
        'firstLine': r'\mathbf{4 -4(\cos x - \sin x) - \sin 2x = 0}',
        'secondLine': [
          'නම්',
          r'\mathbf{x}',
          'හි',
        ],
        'thirdLine': 'අගය පහතින් තෝරන්න.',
      },
      'answers': [
        r'x = 2n\pi',
        r'x = 2n\pi \pm \frac \pi 4 + \frac \pi 2',
        r'x = n\pi - \frac \pi 2',
        r'x = n\pi - \frac \pi 4',
        r'x = 2n\pi \pm \frac \pi 4 - \frac \pi 4',
      ],
      'answer': r'x = 2n\pi \pm \frac \pi 4 - \frac \pi 4',
    }
  },
  'Psi':{
    'part1':{
      'question': {
        'firstLine': r'\mathbf{\tan x + \tan 2x +\tan 3x = 0}',
        'secondLine': [
          'සමීකරණය විසඳා',
          r'\mathbf{\theta}',
          'හි',
        ],
        'thirdLine': 'සාදාරන විසඳුම් පහතින් තෝරන්න.',
        'forthLine': r'\mathbf{\tan\bm\alpha = \frac 1 {\sqrt 2}}'
      },
      'answers': [
        r'x = \frac {n\pi} 3 \text{ } \bm{or}\text{ } x = n\pi + \alpha',
        r'x = 2n\pi \text{ } \bm{or}\text{ } x = n\pi - \alpha',
        r'x = \frac {n\pi} 3 \text{ } \bm{or}\text{ } x = n\pi \pm \alpha',
        r'x = \frac {n\pi} 2 \text{ } \bm{or}\text{ } x = \frac {n\pi} 3 \pm \alpha',
        r'x = \frac {n\pi} 3 \pm \alpha \text{ } \bm{or}\text{ } x = \frac {n\pi} 3',
      ],
      'answer': r'x = \frac {n\pi} 3 \text{ } \bm{or}\text{ } x = n\pi \pm \alpha',
    },
    'part2':{
      'question': {
        'firstLine': r'\mathbf{\cos^{-1} x + \cos^{-1} y + \cos^{-1} z = \pi}',
        'thirdLine': 'නම් පහත කුමන ප්‍රකාශය සත්‍ය වේද?',
      },
      'answers': [
        r'(x + y + z)^2 - 2xyz = 1',
        r'(x - y + z)^2 - 2xyz = 0',
        r'(x + y + z) + 4xyz = 1',
        r'x^2 + y^2 +z^2 + 2xyz = 1',
        r'x^2 - y^2 +z^2 - 2xyz = 0',
      ],
      'answer': r'x^2 + y^2 +z^2 + 2xyz = 1',
    },
    'part3':{
      'question': {
        'firstLine': r'\mathbf{u = \sin \Big(\frac {x+ y} 2\Big), \text{ } v = \cos \Big(\frac {x - y} 2\Big)}',
        'secondLine': [
          'නම් සහ',
          r'\mathbf{\sin x + sin y = \sqrt 2, \text{ } \cos x\cos y = \frac 1 2}',
          '',
        ],
        'thirdLine': 'නම් x හා y හි සාදාරණ විසඳුම් සොයන්න.',
        'forthLine': r'\mathbf{(u, \text{ } v > 0 ) \text{ }\bm{and}\text{ } (n,m \text{  }\bm\epsilon\text{  } \Z)}',
      },
      'answers': [
        r'x = (n-2m)\pi + (-1)^n \frac {\pi} {2}, \text{  } y=(n+2m)\pi + (-1)^n \frac {\pi} {2}',
        r'x = (n+2m)\pi + (-1)^n \frac {\pi} {4}, \text{  } y=(n-2m)\pi + (-1)^n \frac {\pi} {4}',
        r'x = 2(n-2m)\pi + (-1)^n \frac {\pi} {2}, \text{  } y=2(n+2m)\pi + (-1)^n \frac {\pi} {2}',
        r'x = (2m-n)\pi + (-1)^n \frac {\pi} {4}, \text{  } y=(2n-m)\pi + (-1)^n \frac {\pi} {4}',
        r'x = 2(m-n)\pi + (-1)^n \frac {\pi} {2}, \text{  } y=2(n-m)\pi + (-1)^n \frac {\pi} {2}',
      ],
      'answer': r'x = (n+2m)\pi + (-1)^n \frac {\pi} {4}, \text{  } y=(n-2m)\pi + (-1)^n \frac {\pi} {4}',
    }
  },
};