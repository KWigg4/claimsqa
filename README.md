# claimsqa

A practice R package for learning testthat and Jenkins CI. Four small
claims-data cleaning functions, each tested against synthetic fixtures
seeded with known data issues (see `tests/testthat/fixtures/README.md`).

| Function | Planted issues it handles |
|---|---|
| `dedupe_claims()` | Exact duplicate lines |
| `net_reversals()` | Reversals, re-pays, floating point near-zero |
| `collapse_enrollment()` | Overlapping, contained, adjacent, out-of-order spans |
| `first_visit()` | Tied timestamps, out-of-order rows |

## Part 1: Run the tests locally

Open the folder in Positron and run:

```r
devtools::test()          # or testthat::test_local()
```

Expect `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 26 ]`.

To run one file while you work on it:

```r
devtools::test(filter = "first_visit")
```

## Part 2: Put it on GitHub

Create a new repo on your personal account (KWigg4) named `claimsqa`.
Public is simplest, because Jenkins can then clone it without credentials.

```bash
cd claimsqa
git init -b main
git add .
git commit -m "Initial package with tests"
git remote add origin https://github.com/KWigg4/claimsqa.git
git push -u origin main
```

## Part 3: Start Jenkins in Docker

```bash
cd jenkins
docker compose up -d --build
```

The first build takes a few minutes while it installs R. Then get the
one-time admin password:

```bash
docker compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Open http://localhost:8080, paste the password, choose
**Install suggested plugins**, and create an admin user.

## Part 4: Create the pipeline job

1. **New Item** → name it `claimsqa` → choose **Pipeline** → OK.
2. Under **Build Triggers**, check **Poll SCM** and enter `H/2 * * * *`
   (checks GitHub for new commits about every 2 minutes; GitHub
   webhooks can't reach localhost).
3. Under **Pipeline**, set Definition to **Pipeline script from SCM**,
   SCM to **Git**, and Repository URL to your repo.
4. Change **Branch Specifier** from `*/master` to `*/main`.
5. Leave Script Path as `Jenkinsfile`. Save.
6. Click **Build Now**.

You should see three green stages. Open the build and click
**Test Result** to see every test listed by name.

## Part 5: Break it on purpose

In `R/first_visit.R`, remove the tiebreaker:

```r
# before
out <- visits[order(visits$pat_id, visits$arrival, visits$visit_id), ,
# after
out <- visits[order(visits$pat_id, visits$arrival), ,
```

Commit and push. Within a couple of minutes Jenkins builds, the
**Unit tests** stage goes red, and Test Result names the two failing
tests. That's a regression test catching a regression. Restore the line,
push again, and watch it go green.

## Part 6: Add your own

Port an issue from your synthetic Medicaid dataset:

1. Add rows to a fixture CSV (or a new one) that plant the issue.
   Fake data only; never real records.
2. Write the test first and confirm it fails.
3. Write or fix the function until it passes.
4. Push, and let Jenkins confirm.

## Stopping and restarting Jenkins

```bash
docker compose stop      # pause; config is kept
docker compose start     # resume
docker compose down -v   # remove everything, including job history
```
