import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class XrayInstallerRegressionTests(unittest.TestCase):
    def test_generated_xray_config_is_valid_json(self):
        script = (ROOT / "install/ins-xray.sh").read_text()
        match = re.search(
            r"cat > /etc/xray/config\.json << END\n(.*?)\nEND", script, re.S
        )
        self.assertIsNotNone(match, "Xray config heredoc must exist")
        rendered = match.group(1).replace(
            "${uuid}", "00000000-0000-4000-8000-000000000000"
        )
        json.loads(rendered)

    def test_xray_domain_substitution_expands_domain(self):
        script = (ROOT / "install/ins-xray.sh").read_text()
        self.assertIn('sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf', script)
        self.assertIn('sed -i "s/xxx/${domain}/g" /etc/haproxy/haproxy.cfg', script)

    def test_xray_services_validate_configs_before_restart(self):
        script = (ROOT / "install/ins-xray.sh").read_text()
        self.assertLess(script.index("xray run -test"), script.index("systemctl restart xray"))
        self.assertLess(script.index("nginx -t"), script.index("systemctl restart nginx"))
        self.assertLess(script.index("haproxy -c"), script.index("systemctl restart haproxy"))
        self.assertNotIn("systemctl restart runn", script)


class SshInstallerRegressionTests(unittest.TestCase):
    def test_default_route_detection_does_not_depend_on_unset_variable(self):
        script = (ROOT / "install/ssh-vpn.sh").read_text()
        self.assertRegex(script, r"ip\s+-o\s+-4\s+route\s+show\s+default")
        self.assertNotRegex(script, r"ip\s+-o\s+\$ANU\s+-4\s+route")
        self.assertIn('exit 1', script[script.index('NET='):script.index('if [[ -f /etc/os-release ]]')])

    def test_ports_are_installed_even_when_default_port_is_commented(self):
        script = (ROOT / "install/ssh-vpn.sh").read_text()
        self.assertIn("/etc/ssh/sshd_config.d/00-kapal-api.conf", script)
        self.assertIn("sshd -t", script)
        self.assertIn("/etc/systemd/system/ssh.socket.d/00-kapal-api.conf", script)
        self.assertRegex(script, r"ListenStream=40000")
        self.assertRegex(script, r"Port\s+40000")
        self.assertIn('ss -H -ltn', script)


if __name__ == "__main__":
    unittest.main()
