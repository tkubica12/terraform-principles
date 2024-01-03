# Terraform principles

**Key benefits of Infrastructure as Code:**
- Repeatable outcomes regardless who and when executes it (unlike humans copy and pasting)
- Consistent and durable (unlike PDF with screenshots)
- Unit of work that can be handed over with consistent results (unlike "release notes")
- Version controlled (who change what, ability to roll back to good state)
- Change management using Git (approvals, security checks, automated tests)
- Always consistent executable documentation - it can be executed and enforced by robots, rather than read and incosistently executed by humans (or be create after the fact)
- Ability to instantly spin-up new environments (increase agility and saves costs by not running infrastructure then does not need run 24x7)

**Key principles:**
- [Abstractions and interfaces](./abstractions_and_interfaces/README.md)
- [Sharing data between roots](./sharing_data_between_roots/README.md)
- [Develop stateless helper modules](./helper_modules/README.md)
- Separate manifests as multi-tool single source of truth
- Accessing data between instances and systems
- [GitOps processes](./gitops/README.md)
- Policy as Code
- Documentation as Code