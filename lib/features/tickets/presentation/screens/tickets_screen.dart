import 'package:cinema_app/features/tickets/presentation/providers/tickets_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../widgets/ticket_item_widget.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketsProvider>(context, listen: false).loadUserTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticketsProvider = Provider.of<TicketsProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        context.go('/home');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tickets'),
          backgroundColor: const Color(0xFF121212),
          foregroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
        ),
        body: ticketsProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ticketsProvider.tickets.isEmpty
                ? const Center(
                    child: Text(
                      'You don\'t have any tickets yet',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: ticketsProvider.tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = ticketsProvider.tickets[index];
                      return TicketItemWidget(
                        ticket: ticket,
                        onTap: () => context.go('/ticket-detail', extra: ticket),
                        onDelete: () {}, // Keep empty for now
                      );
                    },
                  ),
      ),
    );
  }
}