// import 'package:cinema_app/features/booking/presentation/providers/booking_provider.dart';
import 'package:cinema_app/features/tickets/presentation/providers/tickets_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../widgets/ticket_item_widget.dart';
// import '../../../../shared/widgets/ticket_menu_widget.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final ticketsProvider = Provider.of<TicketsProvider>(context);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        context.go('/home');
        return false; // Prevent default back behavior
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
      body: ticketsProvider.tickets.isEmpty
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
                // return TicketItemWidget(
                //   ticket: ticket,
                //   onTap: () => context.go('/ticket-detail', extra: ticket),
                //   // onDelete: () => ticketsProvider.deleteTicket(ticket.id),
                // );
              },
            ),
    ),
    );
  }
}