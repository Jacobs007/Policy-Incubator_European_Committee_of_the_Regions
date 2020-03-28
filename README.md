# Policy-Incubator challenge (2020), imposed by the European Committee of the Regions

Contents:
- A method for stratified random sampling in small-N studies (stratification based on one background variable).
(*The file: 20-03-03-140325 contains a partial revision of the initial sample*).
- A Wordfish analysis both with the Text-Mining library (TM) and the Quanteda library.
- Graphics resulting from the Wordfish analysis.
- The extracted pieces of text from each manifesto.
- The data can be found [here](https://github.com/Jacobs007/Data_Policy_Incubator_CoR_2020).

Remarks:
- The wordclouds are produced after the data was stemmed, hence the words sometimes seem a little unnatural. 
- The estimates produced by the TM-version and Quanteda-version differ. This is due to Quanteda relying largely on a different implementation of Wordfish (see: Lowe, W and Benoit, K.R. (2013). Validating Estimates of Latent Traits from Textual Data Using Human Judgment as a Benchmark. *Political Analysis*. 21(3) 298-313). The estimates produced by Quanteda therefore function as a robustness check for the sensitivity of the results to methedological assumptions. Our primary results are based on the original implementation of Wordfish as outlined in: Slapin, J. and Proksch, S.O. (2008). A Scaling Model for Estimating Time-Series Party Positions from Texts. *American Journal of Political Science*. 52(3) 705-772.

**Disclaimer**:
This online appendix is part of a research project in cooperation with the European Committee of the Regions. Any views expressed in this research do not necessarily reflect those of the European Committee of the Regions. While writing this research, no author declared to have conflict of interest with the European Committee of the Regions nor any other organisation. We are grateful for the constructive comments of our project-supervisor Dr Miriam Sorace, but would like to emphasize that any error is the sole responsibility of the authors.
