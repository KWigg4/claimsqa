// Declarative pipeline: Jenkins reads this file from the repo and runs it
// on every build. Each stage must pass before the next one starts.
pipeline {
  agent any

  environment {
    // Pin the locale. Sorting and string handling can change with locale,
    // which is one more way the same input can give different output.
    LANG   = 'C.UTF-8'
    LC_ALL = 'C.UTF-8'
  }

  stages {
    stage('Environment') {
      steps {
        // Log versions so every build records what it ran on
        sh '''
          R --version | head -1
          Rscript -e 'cat("testthat", format(packageVersion("testthat")), "\n")'
        '''
      }
    }

    stage('Unit tests') {
      steps {
        // JunitReporter writes results Jenkins can display per test.
        // stop_on_failure = TRUE makes R exit nonzero, which fails the build.
        sh '''
          mkdir -p test-results
          Rscript -e 'out <- file.path(normalizePath("test-results"), "junit.xml"); testthat::test_local(reporter = testthat::JunitReporter$new(file = out), stop_on_failure = TRUE)'
        '''
      }
    }

    stage('R CMD check') {
      steps {
        // Builds the package and runs CRAN-style checks (tests run again here)
        sh '''
          rm -rf claimsqa_*.tar.gz claimsqa.Rcheck
          R CMD build .
          R CMD check --no-manual claimsqa_*.tar.gz
        '''
      }
    }
  }

  post {
    always {
      junit allowEmptyResults: true, testResults: 'test-results/junit.xml'
      archiveArtifacts allowEmptyArchive: true,
                       artifacts: 'claimsqa.Rcheck/00check.log'
    }
  }
}
