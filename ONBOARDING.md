# Onboarding (CEO: finish these before any other goal, then mark each [x] and commit)

- [x] Confirm `claude plugin list` shows `hq@ai-company` enabled. If not, run `claude plugin marketplace add C:\AI\departments` then `claude plugin install hq@ai-company`.
- [x] Hermes: if `hermes` is installed, add `C:/AI/departments/hq/skills` to `skills.external_dirs` in `%USERPROFILE%\.hermes\config.yaml` (back it up first, keep existing keys, never touch `.env`). Verify with `hermes status`.
- [x] GitHub: if `gh auth status` succeeds, create private repo `ferotaiten/ai-company` and push `C:\AI`. If not logged in, file a request.
- [x] Write the final onboarding report in the owner format.
