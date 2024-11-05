Copy of the verifythis website for migration purpose


1. 
```
touch solutions.txt
```

2. Run wget 
```
cat solutions.txt | xargs  wget --mirror --convert-links --adjust-extension --page-requisites --no-parent --span-hosts -e robots=off -t 1 -k  'https://www.pm.inf.ethz.ch/research/verifythis/' https://www.pm.inf.ethz.ch/research/verifythis/Archive/201{1..9}.html https://www.pm.inf.ethz.ch/research/verifythis/Participation.html  https://www.pm.inf.ethz.ch/research/verifythis/Program.html https://www.pm.inf.ethz.ch/research/verifythis/Challenges.html https://www.pm.inf.ethz.ch/research/verifythis/Solutions.html https://www.pm.inf.ethz.ch/research/verifythis/Prizes.html https://www.pm.inf.ethz.ch/research/verifythis/Callforproblems.html https://www.pm.inf.ethz.ch/research/verifythis/Archive.html https://www.pm.inf.ethz.ch/research/verifythis/Archive/202{0..4}.html
```

3.
Extract documents:

```
grep -ohP '"https://ethz.ch/content/dam/ethz/special-interest/infk/chair-program-method/pm/documents/.*?"'  **/** > solutions.txt
```


4. Run (2) again, because now `solution.txt` is filled. 


