import click


def validate_typing():
    click.confirm("Is everything typed?", abort=True)
    click.confirm("Is everything that should be hashable, hashable?", abort=True)


def validate_variable_names():
    click.confirm("Do your variable names make sense?", abort=True)
    click.confirm("Are your variable names consistent?", abort=True)


def validate_feature_correctness():
    click.confirm(
        "Does it meet the Acceptance Criteria?",
        abort=True,
    )
    click.confirm(
        "Did you check the functions you call, and do they make sense in the bigger picture?",
        abort=True,
    )
    click.confirm(
        "If you changed a function, does it impact any of its calling members?",
        abort=True,
    )
    click.confirm(
        "If you created an alternative on an interface/class, does the original one still work?",
        abort=True,
    )


def validate_sensible_statements():
    click.confirm("Are your statements sensible? Should they be compacted?", abort=True)
    click.confirm("Does your API make sense?", abort=True)


def validate_changelog():
    click.confirm("Did you add/update to the changelog and/or readme?", abort=True)


def validate_tests():
    click.confirm("Did you write happy-path tests?", abort=True)
    click.confirm("What about the sad-path tests?", abort=True)
    click.confirm("Do all tests pass?", abort=True)
    click.confirm("Do you have to run the dockerized tests?", abort=True)


def validate_documentation():
    click.confirm("Did you document your changes?", abort=True)
    click.confirm(
        "Can a reader find intent out of your code, "
        "or have you added relevant comments?",
        abort=True,
    )
    click.confirm(
        "Did you add logging in the right locations with sensible names?", abort=True
    )
    click.confirm("Would the logging work? Are all items printable?", abort=True)
    click.confirm("Is your writing style sensible and coherent?", abort=True)


def validate_refactoring():
    click.confirm("Did you write consistent invariants?", abort=True)
    click.confirm(
        "Take a look at the written functions and try to isolate side effects",
        abort=True,
    )
    click.confirm("Did you minimize mutable state influences?", abort=True)
    click.confirm("YAGNI?", abort=True)
    click.confirm("Did you make clear chunks of functions/classes?", abort=True)
    click.confirm("Did you create domain-specific classes where useful?", abort=True)
    click.confirm(
        "Did you efficiently and effectively used polymorphism where useful?",
        abort=True,
    )
    click.confirm("Did you remove redundant code?", abort=True)


def validate_new_issues_created():
    click.confirm(
        "Did you create relevant issues for what you found and didn't solve?",
        abort=True,
    )


def validate_debug():
    click.confirm("Cleared out all breakpoints?", abort=True)
    click.confirm("Cleared out all prints?", abort=True)


def validate_git():
    click.confirm("Is everything added and committed?", abort=True)


if __name__ == "__main__":
    try:
        for key, value in list(globals().items()):
            if callable(value) and key.startswith("validate"):
                value()
    except click.exceptions.Abort:
        click.echo(click.style("\nThen I'll see you again once it's done!", fg="red"))
        exit(1)
    else:
        click.echo(click.style("\nGood job! Create a PR then, ya gabber!", fg="green"))
