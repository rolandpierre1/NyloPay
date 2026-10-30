import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_cash/data/api/api_client.dart';
import 'package:url_launcher/url_launcher.dart';

/// Retrait automatique vers le compte bancaire via Stripe.
class BankWithdrawScreen extends StatefulWidget {
  const BankWithdrawScreen({super.key});

  @override
  State<BankWithdrawScreen> createState() => _BankWithdrawScreenState();
}

class _BankWithdrawScreenState extends State<BankWithdrawScreen> with WidgetsBindingObserver {
  static const String _base = '/api/v1/customer';

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  bool _loading = true;
  bool _busy = false;
  bool _linked = false;
  double _minAmount = 1;
  String _currency = '';
  List<Map<String, dynamic>> _tiers = [];
  String? _error;

  bool get _fr => (Get.locale?.languageCode ?? 'en') == 'fr';
  String _t(String fr, String en) => _fr ? fr : en;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Retour depuis la page Stripe : on relit l'état du compte bancaire.
    if (state == AppLifecycleState.resumed) {
      _loadStatus(silent: true);
    }
  }

  double _num(dynamic v) => v == null ? 0 : double.tryParse(v.toString()) ?? 0;

  Future<void> _loadStatus({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);
    final response = await Get.find<ApiClient>().getData('$_base/bank-status');
    if (!mounted) return;
    if (response.statusCode == 200 && response.body is Map) {
      final b = response.body as Map;
      setState(() {
        _linked = b['bank_linked'] == true;
        _minAmount = _num(b['min_amount']);
        _currency = (b['currency'] ?? '').toString();
        _tiers = (b['tiers'] as List? ?? []).map((e) => Map<String, dynamic>.from(e as Map)).toList();
        _error = null;
        _loading = false;
      });
    } else {
      setState(() {
        _error = _t('Impossible de charger les informations. Réessayez.', 'Could not load information. Try again.');
        _loading = false;
      });
    }
  }

  double _feeFor(double amount) {
    Map<String, dynamic>? best;
    for (final t in _tiers) {
      final min = _num(t['min_amount']);
      final max = t['max_amount'] == null ? null : _num(t['max_amount']);
      if (amount >= min && (max == null || amount < max)) {
        if (best == null || min > _num(best['min_amount'])) best = t;
      }
    }
    if (best == null) return 0;
    return double.parse(((amount * _num(best['percent']) / 100) + _num(best['fixed'])).toStringAsFixed(2));
  }

  void _snack(String message, {bool error = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
    ));
  }

  String _messageFrom(dynamic body, String fallback) {
    if (body is Map) {
      if (body['message'] != null) return body['message'].toString();
      if (body['errors'] is List && (body['errors'] as List).isNotEmpty) {
        final e = (body['errors'] as List).first;
        if (e is Map && e['message'] != null) return e['message'].toString();
      }
    }
    return fallback;
  }

  Future<void> _linkBank() async {
    setState(() => _busy = true);
    final response = await Get.find<ApiClient>().postData('$_base/bank-link', {});
    if (!mounted) return;
    setState(() => _busy = false);
    if (response.statusCode == 200 && response.body is Map && response.body['url'] != null) {
      await launchUrl(Uri.parse(response.body['url'].toString()), mode: LaunchMode.externalApplication);
    } else {
      _snack(_messageFrom(response.body, _t('Erreur, réessayez.', 'Error, try again.')));
    }
  }

  Future<void> _withdraw() async {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
    if (amount <= 0 || amount < _minAmount) {
      _snack('${_t('Montant minimum', 'Minimum amount')} : $_minAmount $_currency');
      return;
    }
    if (_pinController.text.length != 4) {
      _snack(_t('Entrez votre code PIN à 4 chiffres.', 'Enter your 4-digit PIN.'));
      return;
    }
    final fee = _feeFor(amount);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(_t('Confirmer le retrait', 'Confirm withdrawal')),
        content: Text('${_t('Montant reçu en banque', 'Amount to your bank')} : ${amount.toStringAsFixed(2)} $_currency\n'
            '${_t('Frais', 'Fee')} : ${fee.toStringAsFixed(2)} $_currency\n'
            '${_t('Total débité', 'Total debited')} : ${(amount + fee).toStringAsFixed(2)} $_currency'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(_t('Annuler', 'Cancel'))),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: Text(_t('Confirmer', 'Confirm'))),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _busy = true);
    final response = await Get.find<ApiClient>().postData('$_base/withdraw', {
      'pin': _pinController.text,
      'amount': amount.toString(),
    });
    if (!mounted) return;
    setState(() => _busy = false);
    _pinController.clear();

    if (response.statusCode == 200) {
      _amountController.clear();
      _snack(_t('Retrait envoyé vers votre banque. Il arrive en général sous 1 à 3 jours ouvrables.',
          'Withdrawal sent to your bank. It usually arrives within 1-3 business days.'), error: false);
      Navigator.of(context).pop(true);
    } else {
      _snack(_messageFrom(response.body, _t('Le retrait a échoué.', 'The withdrawal failed.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
    final fee = amount > 0 ? _feeFor(amount) : 0.0;

    return Scaffold(
      appBar: AppBar(title: Text(_t('Retrait vers ma banque', 'Withdraw to my bank'))),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(onPressed: _loadStatus, child: Text(_t('Réessayer', 'Retry'))),
                    ]),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => _loadStatus(silent: true),
                  child: ListView(padding: const EdgeInsets.all(20), children: [
                    if (!_linked) ..._buildLinkSection() else ..._buildWithdrawSection(amount, fee),
                  ]),
                ),
    );
  }

  List<Widget> _buildLinkSection() {
    return [
      const SizedBox(height: 12),
      const Icon(Icons.account_balance, size: 64),
      const SizedBox(height: 16),
      Text(
        _t('Liez votre compte bancaire pour retirer votre argent. Vous serez redirigé vers la page sécurisée de Stripe.',
            'Link your bank account to withdraw your money. You will be redirected to the secure Stripe page.'),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      ElevatedButton(
        onPressed: _busy ? null : _linkBank,
        child: _busy
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(_t('Lier mon compte bancaire', 'Link my bank account')),
      ),
      const SizedBox(height: 12),
      TextButton(onPressed: () => _loadStatus(), child: Text(_t("J'ai terminé, actualiser", "I'm done, refresh"))),
    ];
  }

  List<Widget> _buildWithdrawSection(double amount, double fee) {
    return [
      Row(children: [
        const Icon(Icons.check_circle, color: Colors.green),
        const SizedBox(width: 8),
        Expanded(child: Text(_t('Compte bancaire lié', 'Bank account linked'))),
        TextButton(onPressed: _busy ? null : _linkBank, child: Text(_t('Modifier', 'Change'))),
      ]),
      const SizedBox(height: 16),
      TextField(
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
        decoration: InputDecoration(
          labelText: '${_t('Montant à recevoir en banque', 'Amount to receive')} ($_currency)',
          border: const OutlineInputBorder(),
        ),
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: 8),
      Text('${_t('Retrait minimum', 'Minimum withdrawal')} : $_minAmount $_currency',
          style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 16),
      if (amount > 0)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              _row(_t('Montant', 'Amount'), amount),
              _row(_t('Frais', 'Fee'), fee),
              const Divider(),
              _row(_t('Total débité de votre solde', 'Total debited from your balance'), amount + fee, bold: true),
            ]),
          ),
        ),
      const SizedBox(height: 16),
      TextField(
        controller: _pinController,
        obscureText: true,
        keyboardType: TextInputType.number,
        maxLength: 4,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: _t('Code PIN', 'PIN'),
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 12),
      ElevatedButton(
        onPressed: _busy ? null : _withdraw,
        child: _busy
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(_t('Retirer', 'Withdraw')),
      ),
    ];
  }

  Widget _row(String label, double value, {bool bold = false}) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(child: Text(label, style: style)),
        Text('${value.toStringAsFixed(2)} $_currency', style: style),
      ]),
    );
  }
}
