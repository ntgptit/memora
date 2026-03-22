#!/usr/bin/env python3
"""
Frontend checklist guard entrypoint.

Run:
  python tool/verify_frontend_checklists.py
  python tool/verify_frontend_checklists.py --strict
"""

from frontend_guard.core import main


if __name__ == "__main__":
    raise SystemExit(main())
