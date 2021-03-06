from invoke import Collection, Program, Argument
from dstack_factory import tasks


class FactoryProgram(Program):
    def core_args(self):
        core_args = super(FactoryProgram, self).core_args()
        extra_args = [
            Argument(names=('project', 'n'), help="The project/package name being build"),
        ]
        return core_args + extra_args

program = FactoryProgram(namespace=Collection.from_module(tasks), version='1.0.5')
