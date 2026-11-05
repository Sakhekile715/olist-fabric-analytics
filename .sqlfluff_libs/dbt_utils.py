"""Stub of dbt_utils for sqlfluff's jinja templater.

Lets models render without a dbt project compile (which on Fabric needs a live
warehouse connection). Only the shape of the output matters for linting.
"""


def generate_surrogate_key(field_list):
    return "surrogate_key"
