import argparse
import platform
import subprocess
import sys
from time import sleep

from rich.progress import track

timers = {
    "work": 25 * 60,
    "break": 5 * 60,
    "study": 10 * 60,
    "tea": 3 * 1,
    "mate": 8 * 60,
}


def get_arg_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        formatter_class=argparse.RawTextHelpFormatter,
    )
    p.add_argument("timer", choices=timers.keys(), help="timers")
    return p


def pomodoro(timer_name: str, duration_s: int | None = None):
    if not duration_s:
        assert timer_name in timers
        duration_s = timers[timer_name]

    for _ in track(
        range(duration_s), description=f"{timer_name.capitalize()} session..."
    ):
        sleep(1)

    system = platform.system()
    try:
        getattr(sys.modules[__name__], f"notify_{system.lower()}")(timer_name)
    except:
        notify_none(timer_name)


def notify_darwin(timer_name: str):
    subprocess.run(["say", "-v", "Zarvox", f"{timer_name} session done. ."])
    subprocess.run(
        [
            "osascript",
            "-e",
            f'display notification "☕" with title "{timer_name} timer is up!" sound name "Crystal"',
        ]
    )


def notify_linux(timer_name: str):
    subprocess.run(["spd-say", f"{timer_name} session done"])
    subprocess.run(
        ["notify-send", "--app-name=Pomodoro🍅", f"{timer_name} timer is up! ☕"]
    )


def notify_none(timer_name):
    print(f"Unknown OS, but we finished {timer_name} anyway.")


def run(iterations: int):
    for _ in range(iterations):
        pomodoro("work")
        pomodoro("break")


if __name__ == "__main__":
    args = get_arg_parser().parse_args()
    pomodoro(args.timer)
